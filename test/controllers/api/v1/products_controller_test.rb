require 'test_helper'

class Api::V1::ProductsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::ProductsController.new
    @request.host = 'api.standoutcms.dev'

    @product_category = ProductCategory.create(
      slug: 'Lorem ipsum',
      website_id: websites(:standout).id
    )
    @product = @product_category.products.create(
      title: 'Lorem ipsum',
      url: '/one',
      website_id: websites(:standout).id
    )
  end

  test 'index should return all products for the current category' do
    get :index, format: :json, product_category_id: @product_category.id
    assert_response :success
    assert_equal @response.body, @product_category.products.to_json
  end

  test 'index with filter should return all matching products for the current category' do
    get :index, format: :json, product_category_id: product_categories(:one).id, pages: "above200"
    assert_response :success
    assert_equal @response.body, [products(:one)].to_json
  end

  test 'index with search string should return all matching products for the current category' do
    get :index, format: :json, product_category_id: product_categories(:one).id, query_string: "Test"
    assert_response :success
    assert_equal @response.body, [products(:testproduct), products(:two)].to_json
  end

  test 'show should return the current product' do
    get :show, format: :json, id: @product.id
    assert_response :success
    assert_equal @response.body, @product.to_json
  end
end
