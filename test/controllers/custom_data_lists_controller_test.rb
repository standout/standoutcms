require 'test_helper'

class Admin::CustomDataListsControllerTest < ActionController::TestCase

  def setup
    request.host = "standout.standoutcms.dev"
  end

  test 'should not get to the controller without login' do
    get :index
    assert_response :redirect    
  end
  
  test 'should render the index page without crashing' do
    login_as(:david)
    get :index
    assert_response :success
  end
  
end
