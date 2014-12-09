class Api::V1::ProductsController < Api::V1::BaseController
  def index
    resource = params[:product_category_id] ?
      ProductCategory.find(params[:product_category_id]) :
      Website.find(params[:website_id])
    @products = resource.search_and_filter(params)
    render 'products/index'
  end

  def show
    @product = Product.find(params[:id])
    render json: @product.to_json
  end
end
