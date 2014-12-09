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
    products = JSON.parse(@response.body)
    products.each do |p|
      assert p['product_category_ids'].include?(@product_category.id)
    end
  end

  test 'index with filter should return all matching products for the current category' do
    get :index, format: :json, product_category_id: product_categories(:one).id, pages: "above200"
    assert_response :success
    assert_equal JSON.parse(@response.body).first['title'], products(:one).title
  end

  test 'index with search string should return all matching products for the current category' do
    get :index, format: :json, product_category_id: product_categories(:one).id, query_string: "Test"
    assert_response :success
    prods = JSON.parse(@response.body)
    assert prods.collect{ |p| p['id'] }.flatten.include?(products(:testproduct).id)
  end

  test 'show should return the current product' do
    get :show, format: :json, id: @product.id
    assert_response :success
    prod = JSON.parse(@response.body)
    assert_equal prod['id'], @product.id
  end
end
