class Admin::ShippingCostsController < ApplicationController
  layout 'webshop'
  before_filter :check_login
  before_filter :load_website

  def load_website
    if current_user.admin?
      @website = current_website
    else
      @website = current_user.websites.find(current_website.id)
    end
  end

  def index
    @shipping_costs = @website.shipping_costs.order('from_value ASC')
  end

  def new
    @shipping_cost = @website.shipping_costs.new
  end

  def create
    @shipping_cost = @website.shipping_costs.new(params[:shipping_cost])

    if @shipping_cost.save
      redirect_to admin_shipping_costs_path
    else
      render action: :new
    end
  end

  def edit
    @shipping_cost = @website.shipping_costs.find(params[:id])
  end

  def update
    @shipping_cost = @website.shipping_costs.find(params[:id])

    if @shipping_cost.update_attributes(params[:shipping_cost])
      redirect_to admin_shipping_costs_path
    else
      render action: :edit
    end
  end

  def destroy
    @website.shipping_costs.find(params[:id]).destroy
    redirect_to admin_shipping_costs_path
  end
end
