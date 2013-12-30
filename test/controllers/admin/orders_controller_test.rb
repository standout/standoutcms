require 'test_helper'

class Admin::OrdersControllerTest < ActionController::TestCase

  def setup
    request.host = "standout.standoutcms.dev"
  end

  test 'loading the list of orders when not logged in should not work' do
    get :index
    assert_response :redirect
  end

  test 'loading the list of orders as a logged in user should work' do
    session[:user_id] = users(:david).id
    get :index
    assert_response :success
  end

end