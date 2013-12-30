require 'test_helper'

class Api::V1::CartsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::CartsController.new
    @request.host = 'api.standoutcms.dev'
  end

  test 'create should create a new cart and return it' do
    post :create, format: :json, website_id: websites(:standout).id
    assert_response :success
    assert_equal @response.body, Cart.last.to_json
  end

  test 'show should return a cart' do
    get :show, format: :json, id: carts(:one).api_key
    assert_response :success
    assert_equal @response.body, carts(:one).to_json
  end

  test 'update should update a cart and return it' do
    get :update, format: :json, id: carts(:one).api_key, notes: 'test'
    assert_response :success
    assert_equal @response.body, Cart.find(carts(:one).id).to_json
  end

  test 'empty should remove all cart items in a cart' do
    carts(:one).cart_items.create(product_id: products(:one).id)
    get :empty, format: :json, id: carts(:one).api_key
    assert_response :success
    assert_equal carts(:one).cart_items.size, 0
  end
end
