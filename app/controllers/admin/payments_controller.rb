module Admin
  class PaymentsController < ApplicationController
    layout 'webshop'
    before_filter :check_login

    def update
      paid     = params[:payment][:paid] == 'true' ? true : false
      @order   = current_website.orders.find(params[:order_id])
      @payment = @order.payment

      if paid
        @payment.update_payment(true, 'invoice')
      else
        @payment.update_payment(false)
      end

      redirect_to :back
    end
  end
end