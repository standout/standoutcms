require 'test_helper'

class Api::V1::OrdersControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::OrdersController.new
    @request.host = 'api.standoutcms.dev'
  end

  test 'create should create a new order and return it' do
    post :create, {
      format: :json,
      website_id: websites(:standout).id,
      cart_api_key: carts(:one).api_key,
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@doe.com',
      address_line1: 'Example street 1',
      zipcode: '12345',
      city: 'Example city',
      vat_identification_number: '12345',
      inquiry: true
    }
    assert_response :success
    assert_equal @response.body, Order.last.to_json
  end
end
