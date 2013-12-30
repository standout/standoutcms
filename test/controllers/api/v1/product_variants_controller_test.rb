require 'test_helper'

class Api::V1::ProductVariantsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::ProductVariantsController.new
    @request.host = 'api.standoutcms.dev'

    @product = Product.create!(
      title: 'Lorem ipsum',
      url: '/one',
      website_id: websites(:standout).id
    )
    @product_variant = ProductVariant.create!(product_id: @product.id)
  end

  test 'index should return all products variants for the current product' do
    get :index, format: :json, product_id: @product.id
    assert_response :success
    assert_equal @response.body, @product.product_variants.to_json
  end

  test 'show should return the current product variant' do
    get :show, format: :json, id: @product_variant.id
    assert_response :success
    assert_equal @response.body, @product_variant.to_json
  end
end
