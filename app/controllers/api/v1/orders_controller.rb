class Api::V1::OrdersController < Api::V1::BaseController
  def create
    @website = Website.find(params[:website_id])
    @cart = Cart.find_by_api_key(params[:cart_api_key])

    if not @cart or not @cart.update(filter_cart_params)
      return render_error
    end

    @customer =
      @website.customers.find_by_email(params[:email]) || @website.customers.new

    unless @customer.update_attribute(:email, params[:email])
      return render_error
    end

    @order = @website.orders.new(filter_order_params)
    @order.payment_type = 'invoice'
    @order.cart = @cart
    @order.customer = @customer
    @customer_information = @order
      .new_customer_information_set(filter_customer_params)

    if params[:delivery_address]
      @delivery_information = @order
        .new_delivery_information_set(
          filter_customer_params(params[:delivery_address])
        )
      return render_error unless @delivery_information.save
    end

    return render_error if not @customer_information.save or not @order.save

    deliver_mail
    render json: @order
  end

  def render_error
    render json: {}, status: 400
  end

  def deliver_mail
    mail = Notifier.order_placed(@website, @customer, @order)
    mail[:to] = @website.email
    mail.deliver
    mail[:to] = @customer.email
    mail.deliver
  end

  # TODO use strong parameters instead

  def filter_params(input, accessible)
    input.select{ |key, value| accessible.include?(key.to_sym) }
  end

  def filter_customer_params(input = nil)
    input ||= params
    filter_params(input, [
      :first_name,
      :last_name,
      :company_name,
      :address_line1,
      :address_line2,
      :zipcode,
      :city,
      :phone,
      :vat_identification_number
    ])
  end

  def filter_order_params
    filter_params params, [:inquiry]
  end

  def filter_cart_params
    filter_params params, [:notes, :reseller]
  end
end
