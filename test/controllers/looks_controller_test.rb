require 'test_helper'

class Admin::LooksControllerTest < ActionController::TestCase
  
  def setup
    request.host = "standout.standoutcms.dev"        
    session[:user_id] = users(:david).id
  end
  
  test 'should_be_able_to_create_a_new_look' do
    get :new
    assert_response :success
    
    number_of_looks = Look.all.size
    
    post :create, :look => { :title => "My look" }
    assert_response :redirect
    
    assert Look.all.size == number_of_looks + 1 
    
    get :index
    assert_response :success
  end
  
  test 'should be able to view edit page of look' do
    get :edit, :id => Look.first.id
    assert_response :success
  end
  
end
