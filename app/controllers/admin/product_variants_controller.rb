class Admin::ProductVariantsController < ApplicationController

  respond_to :html, :json

  before_filter :check_login

  def create
    @product = current_website.products.find(params[:product_id])
    @product_variant = ProductVariant.new(product_variant_params)
    @product_variant.product_id = @product.id
    if @product_variant.save
      respond_to do |format|
        format.html { redirect_to [:edit, :admin, @product] }
        format.json { respond_with @product.to_json }
      end
    else
      render :text => 'not saved'
    end
  end
  
  def destroy
    @product = current_website.products.find(params[:product_id])
    @product_variant = @product.product_variants.find(params[:id])
    if @product_variant.destroy
      respond_to do |format|
        format.html { redirect_to [:edit, :admin, @product] }
        format.json { respond_with @product_variant.to_json }
      end
    end
  end
  
  def update
    @product = current_website.products.find(params[:product_id])
    @product_variant = @product.product_variants.find(params[:id])
    if @product_variant.update(product_variant_params)
      respond_with(@product_variant.to_json)
    end
  end

  private

  def product_variant_params
    params.require(:product_variant).permit %i(
      product_id
      color
      size
      material
      price
      inventory
    )
  end

end
