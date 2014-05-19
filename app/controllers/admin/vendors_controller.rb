class Admin::VendorsController < ApplicationController

  layout 'webshop'
  before_filter :check_login

  def index
    @vendors = current_website.vendors.order("name asc")
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)
    @vendor.website_id = current_website.id
    if @vendor.save
      redirect_to [:admin, :vendors], :notice => t('notices.vendor.added')
    else
      render :new
    end
  end

  def edit
    @vendor = current_website.vendors.find(params[:id])
  end

  def update
    @vendor = current_website.vendors.find(params[:id])
    @vendor.update(vendor_params)
    @vendor.website_id = current_website.id
    redirect_to [:admin, :vendors]
  end

  def destroy
    @vendor = current_website.vendors.find(params[:id])
    @vendor.destroy
    redirect_to [:admin, :vendors]
  end

  private

  def vendor_params
    params.require(:vendor).permit %i(
      name
      logo
      slug
      logo_file_name
      logo_content_type
      logo_file_size
      logo_updated_at
    )
  end

end
