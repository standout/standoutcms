class Api::V1::ProductVariantsController < Api::V1::BaseController
  def index
    @product = Product.find(params[:product_id])
    @product_variants = @product.product_variants
    render json: @product_variants
  end

  def show
    @product_variant = ProductVariant.find(params[:id])
    render json: @product_variant
  end
end
