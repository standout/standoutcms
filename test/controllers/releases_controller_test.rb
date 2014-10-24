require 'test_helper'

class Admin::ReleasesControllerTest < ActionController::TestCase
  
  def setup
    request.host = "standout.standoutcms.dev"
  end
  
  test 'should not be able to view controller without logging in' do
    session[:user_id] = nil
    get :new
    assert_response :redirect
  end
  
  test 'should be able view the page to do a new release' do
    session[:user_id] = users(:david).id
    get :new
    assert_response :success
  end
  
end
