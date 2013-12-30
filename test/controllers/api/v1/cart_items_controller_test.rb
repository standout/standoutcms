require 'test_helper'

class Api::V1::CartItemsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::CartItemsController.new
    @request.host = 'api.standoutcms.dev'
  end

  test 'index should return all cart items in a cart' do
    get :index, format: :json, cart_id: carts(:one).api_key
    assert_response :success
    assert_equal @response.body, carts(:one).cart_items.to_json
  end

  test 'create should create a new cart item and return it' do
    post :create, {
      format:     :json,
      cart_id:    carts(:one).api_key,
      product_id: products(:one).id
    }
    assert_response :success
    assert_equal @response.body, CartItem.last.to_json
  end

  test 'update should update a cart item and return it' do
    get :update, format: :json, id: cart_items(:one).api_key, quantity: 2
    assert_response :success
    assert_equal @response.body, CartItem.find(cart_items(:one).id).to_json
  end

  test 'destroy should remove a cart item' do
    cart_item = CartItem.create(title: 'test', product_id: products(:one).id)
    delete :destroy, id: cart_item.api_key
    assert_response :success
    assert_equal CartItem.where(title: 'test').size, 0
  end
end
