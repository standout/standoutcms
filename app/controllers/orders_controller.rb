class OrdersController < ApplicationController

  protect_from_forgery :except => [:create, :paypal_notification]
  before_filter :load_cart, :except => [:paypal_notification]

  def paypal_notification
    @order = current_website.orders.find(params[:invoice])
    if params[:payment_status] == 'Completed'
      @order.payment.update_payment(true, 'PayPal')
    end
    render :nothing => true
  end

  # Try to create the order and forget the current cart
  def create
    # Make sure a payment type has been set!
    payment_type = params[:order][:payment_type] rescue nil # Kind of ugly fix but it works

    @order = current_website.orders.new((order_params or {}).merge(Hash.new({ cart_id: current_cart.id })))
    @order.website_id = current_website.id
    @customer_information = @order.new_customer_information_set(contact_information_params)
    @customer = current_website.customers.where(email: params[:customer][:email].to_s).first

    if @customer.blank?
      @customer = current_website.customers.new(email: params[:customer][:email])
    end

    if @order.valid? and @customer.valid?
      @customer.save if @customer.new_record?
      @order.cart = current_cart
      @order.cart.reseller = params[:customer][:reseller] if params[:customer]
      @order.cart.save!
      @order.save
      @customer_information.save
      @customer.orders << @order

      session[:cart_id] = nil

      # Send order email
      mail = Notifier.order_placed(current_website, @customer, @order)
      mail[:to] = current_website.email
      mail.deliver
      mail[:to] = @customer.email
      mail.deliver

      respond_to do |format|
        format.html {
          if @order.payment_type == 'invoice'
            redirect_to '/thank_you'
          elsif @order.payment_type == 'paypal'
            # Redirect to PayPal for credit card payment
            redirect_to @order.cart.paypal_url(root_url, paypal_notification_url)
          elsif @order.payment_type == 'dibs'
            # Render Dibs form for credit card payment
            @dibs = DibsPayment.new(@order,
              cancelReturnUrl: dibs_cancel_url,
              acceptReturnUrl: dibs_accept_url,
              callbackUrl: dibs_callback_url(id: @order.id,
                                             token: @order.payment.token))
            render "orders/dibs", layout: "auto_submit"
          end
        }
        format.json {
          render :json => @order.to_json
        }
      end

    else
      @website = current_website
      @page_template = @website.page_templates.where(:slug => 'checkout').first

      user_stuff = {
        'customer' => {
          'first_name'                => @customer_information.first_name,
          'last_name'                 => @customer_information.last_name,
          'email'                     => @customer.email,
          'address_line1'             => @customer_information.address_line1,
          'address_line2'             => @customer_information.address_line2,
          'zipcode'                   => @customer_information.zipcode,
          'city'                      => @customer_information.city,
          'phone'                     => @customer_information.phone,
          'vat_identification_number' => @customer_information.vat_identification_number
        },
        'payment' => {
          'method' => payment_type
        },
        'errors' => errors.map(&:full_messages).flatten,
        'error_fields' => errors.map(&:messages).map(&:keys).flatten.map(&:to_s)
      }

      unless payment_type
        user_stuff['errors'] << t('error_payment_method')
        user_stuff['error_fields'] << 'payment_type'
      end

      respond_to do |format|
        format.html {
          if @page_template.nil?
            render :text => "You need a page template named 'checkout' to render this page."
          else
            render :text => render_the_template(@website, @page_template, current_cart, user_stuff)
          end
        }
        format.json { render :json => user_stuff.to_json }
      end
    end
  end

  def new
    @website = current_website
    @page_template = @website.page_templates.where(:slug => 'checkout').first
    if @page_template.nil?
      render :text => "You need a page template named 'checkout' to render this page."
    else
      render :text => render_the_template(@website, @page_template, current_cart)
    end
  end

  def thank_you
    page_template = current_website.page_templates.where(slug: 'thank_you').first

    if page_template.nil?
      render text: "You need a page template named 'thank_you' to render this page."
    else
      render text: render_the_template(current_website, page_template, current_cart)
    end
  end

  private

  def load_cart
    @cart = current_cart
  end

  def order_params
    params.require(:order).permit %i(
      cart_id
      payment_type
      inquiry
    )
  end

  def contact_information_params(input)
    params.require(:customer).permit %i(
      first_name
      last_name
      company_name
      vat_identification_number
      address_line1
      address_line2
      zipcode
      city
      phone
    )
  end

  def errors
    @customer.valid?
    @customer_information.valid?
    [@customer, @customer_information].map(&:errors)
  end

end
