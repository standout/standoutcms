class Api::V1::OrdersController < Api::V1::BaseController
  def create
    @website = Website.find(params[:website_id])
    @cart = Cart.find_by_api_key(params[:cart_api_key])

    if not @cart or not @cart.update(cart_params)
      return render_error
    end

    @customer =
      @website.customers.find_by_email(params[:email]) || @website.customers.new

    unless @customer.update_attribute(:email, params[:email])
      return render_error
    end

    @order = @website.orders.new(order_params)
    @order.payment_type = 'invoice'
    @order.cart = @cart
    @order.customer = @customer
    @customer_information = @order
      .new_customer_information_set(customer_params)

    if params[:delivery_address]
      @delivery_information = @order
        .new_delivery_information_set(
          customer_params(params[:delivery_address])
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

  private

  def order_params
    params.permit(:inquiry)
  end

  def cart_params
    params.permit(:notes, :reseller)
  end

  def customer_params(input = nil)
    input ||= params
    params.permit %i(
      first_name
      last_name
      company_name
      address_line1
      address_line2
      zipcode
      city
      phone
      vat_identification_number
    )
  end
end
