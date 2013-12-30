class Admin::ProductPropertyKeysController < ApplicationController
  layout 'webshop'
  before_filter :check_login
  before_filter :load_website
  after_filter :update_filtered_attributes, except: :new

  def new
    @product_property_key = @website.product_property_keys.new
  end

  def create
    @product_property_key = @website.product_property_keys.new(params[:product_property_key])

    if @product_property_key.save
      redirect_to edit_webshop_admin_website_path(@website)
    else
      render action: :new
    end
  end

  def edit
    @product_property_key = @website.product_property_keys.find(params[:id])
  end

  def update
    @product_property_key = @website.product_property_keys.find(params[:id])

    if @product_property_key.update_attributes(params[:product_property_key])
      redirect_to edit_webshop_admin_website_path(@website)
    else
      render action: :edit
    end
  end

  def destroy
    @website.product_property_keys.find(params[:id]).destroy
    redirect_to edit_webshop_admin_website_path(@website)
  end

  def load_website
    if current_user.admin?
      @website = current_website
    else
      @website = current_user.websites.find(current_website.id)
    end
  end

  def update_filtered_attributes
    @website.update_filtered_attributes(@website.filtered_attributes)
    @website.save
  end
end
