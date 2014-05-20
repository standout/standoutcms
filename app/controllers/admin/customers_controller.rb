module Admin
  class CustomersController < ApplicationController
    before_filter :check_login
    layout 'webshop'

    def index
      @customers = current_website.customers
    end

    def show
      @customer = current_website.customers.find(params[:id])
    end

    def destroy
      @customer = current_website.customers.find(params[:id])
      @customer.destroy
      redirect_to :back, notice: t('customer_deleted')
    end
  end
end
