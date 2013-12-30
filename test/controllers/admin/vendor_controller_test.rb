require 'test_helper'
class Admin::VendorControllerTest < ActionController::TestCase
  def setup
    @controller = Admin::VendorsController.new
    request.host = "standout.standoutcms.dev"        
    
  end
  
  test 'should not be able to view vendor list without being logged in' do
    get :index
    assert_response :redirect
  end
  
  test 'should_be_able_to_create_vendor' do
    session[:user_id] = users(:david).id
    
    get :index
    assert_response :success
    
    get :new
    assert_response :success
    
    apple_logo = Rack::Test::UploadedFile.new("#{Rails.root}/test/fixtures/apple_logo.jpg", "image/jpeg")
    post :create, :vendor => { :name => 'Apple Inc.', :slug => 'apple', :logo => apple_logo}
    assert_response :redirect
    assert_redirected_to [:admin, :vendors] 
  end
  
end