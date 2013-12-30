require 'test_helper'

class OrdersControllerTest < ActionController::TestCase

  def setup
    request.host = "standout.standoutcms.dev"
    @controller = OrdersController.new
    @customer = {
      :email         => 'david@standout.se',
      :first_name    => 'David',
      :last_name     => 'Svensson',
      :address_line1 => 'Example street 1',
      :zipcode       => '12345',
      :city          => 'Example city'
    }
  end

  test 'should be able to go to the new order page' do
    get :new
    assert_response :success
  end

  test 'creating an order should work' do
    request.env["HTTP_REFERER"] = '/checkout'
    get :new
    orders_count = websites(:standout).orders.size
    cart = Cart.find(assigns(:cart).id)
    cart.add(products(:testproduct))
    post :create, {
      :order    => { :payment_type => 'invoice' },
      :customer => @customer
    }
    assert_response :redirect
    assert_equal(orders_count + 1, websites(:standout).reload.orders.size)
  end

  test "creating an order should create a customer if not exists" do
    cart = Cart.create
    cart.add(products(:testproduct))
    post :create, {
      :order    => { :payment_type => 'invoice' },
      :customer => @customer
    }
    assert Customer.find_by_email('david@standout.se')
    customer_count = Customer.count
    post :create, {
      :order    => { :payment_type => 'invoice' },
      :customer => @customer
    }
    assert_equal customer_count, Customer.count
    assert_response :redirect
  end

  test "that a payment type is required" do
    request.env["HTTP_REFERER"] = '/checkout'
    cart = Cart.create
    cart.add(products(:testproduct))
    order_count = Order.count
    customer_count = Customer.count
    post :create, { customer: @customer }
    assert_equal customer_count, Customer.count
    assert_equal order_count, Customer.count
  end

  test 'reseller should be included in cart if set on customer' do
    cart = Cart.create
    cart.add(products(:testproduct))
    @customer[:reseller] = 'Standout'
    @customer[:email] = 'uniquetest123@standout.se'
    assert_difference 'Customer.count' do
      post :create, { customer: @customer, order: { payment_type: 'invoice' } }
    end
    assert_equal 'Standout', Cart.last.reseller
  end
end
