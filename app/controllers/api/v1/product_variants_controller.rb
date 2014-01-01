class Api::V1::ProductVariantsController < Api::V1::BaseController
  def index
    @product = Product.find(params[:product_id])
    @product_variants = @product.product_variants
    render json: @product_variants.to_json
  end

  def show
    @product_variant = ProductVariant.find(params[:id])
    render json: @product_variant.to_json
  end
end
