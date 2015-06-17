class DibsController < ApplicationController

  def accept
    redirect_to thank_you_url
  end

  def cancel
    redirect_to cart_url
  end

  def callback
    @order = current_website.orders.find_by!(id: params[:id],
                                             payment_type: "dibs")
    @payment = Payment.find_by!(order_id: params[:id], token: params[:token])

    unless DIBS::HMAC.valid?(params, current_website.dibs_hmac_key)
      return head :not_acceptable
    end

    if params[:status] == "ACCEPTED"
      @payment.update_payment(true, "DIBS")
    end

    head :ok
  rescue ActiveRecord::RecordNotFound
    head :not_acceptable
  end

end
