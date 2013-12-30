require 'test_helper'

class Api::V1::ProductCategoriesControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::ProductCategoriesController.new
    @request.host = 'api.standoutcms.dev'
  end

  test 'index should return all first-level categories for the current website' do
    expected_response = websites(:standout)
      .product_categories
      .where(parent_id: nil)
      .to_json

    get :index, format: :json, website_id: websites(:standout).id
    assert_response :success
    assert_equal @response.body, expected_response
  end

  test 'show should return the current product category' do
    get(:show,
      format: :json,
      id: product_categories(:one).id
    )
    assert_response :success
    assert_equal @response.body, product_categories(:one).to_json
  end

  test 'parent should return the parent for the current product category' do
    get(:parent,
      format: :json,
      id: product_categories(:three).id
    )
    assert_response :success
    assert_equal @response.body, product_categories(:one).to_json
  end

  test 'children should return the children for the current product category' do
    get(:children,
      format: :json,
      id: product_categories(:one).id
    )
    assert_response :success
    assert_equal @response.body, product_categories(:one).children.to_json
  end
end
