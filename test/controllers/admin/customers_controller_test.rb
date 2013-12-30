require 'test_helper'

class Admin::CustomersControllerTest < ActionController::TestCase

  def setup
    request.host = "standout.standoutcms.dev"
  end

  test 'loading the list of customers when not logged in should not work' do
    get :index
    assert_response :redirect
  end

  test 'loading the list of customers as a logged in user should work' do
    session[:user_id] = users(:david).id
    get :index
    assert_response :success
  end

  test 'show a customer when not logged in should not work' do
    get :show, id: customers(:one).id
    assert_response :redirect
  end

end