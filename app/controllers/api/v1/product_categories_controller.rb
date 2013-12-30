class Api::V1::ProductCategoriesController < Api::V1::BaseController
  before_filter :find_product_category, except: :index

  def index
    @website = Website.find(params[:website_id])
    @product_categories = @website.product_categories.where(parent_id: nil)
    render json: @product_categories
  end

  def show
    render json: @product_category
  end

  def parent
    render json: @product_category.parent
  end

  def children
    render json: @product_category.children
  end

  def find_product_category
    @product_category = ProductCategory.find(params[:id])
  end
end
