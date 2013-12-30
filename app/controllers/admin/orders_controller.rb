class Admin::OrdersController < ApplicationController

  layout 'webshop'
  before_filter :check_login

  def index
    @orders = current_website.orders
  end

  def show
    @order = current_website.orders.find(params[:id])
  end

  def destroy
    @order = current_website.orders.find(params[:id])
    @order.destroy
    redirect_to :back, notice: 'Order raderad!'
  end
end
