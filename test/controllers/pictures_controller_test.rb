require 'test_helper'
class Admin::PicturesControllerTest < ActionController::TestCase
  def setup
    request.host = "standout.standoutcms.dev"
    session[:user_id] = users(:david).id
  end
  
  test 'should not be able to view view my pictures' do
    get :index
    assert_response :success
  end
  
  test 'picture should be uploaded' do
    get :index
    assert_response :success
    
    apple_logo = Rack::Test::UploadedFile.new("#{Rails.root}/test/fixtures/apple_logo.jpg", "image/jpeg")
    post :create, picture: { name: 'Apple Inc.', slug: 'apple', logo: apple_logo }
    assert_response :redirect
    assert_redirected_to [:admin, :pictures] 
    assert_equal I18n.t('notices.picture.created'), flash[:notice]
  end
  
  test 'should not be able to view pictures without logging in' do
    session[:user_id] = nil
    get :index
    assert_response :redirect
  end

  test 'should be able to remove a picture' do
    p = Picture.create(:data => File.new("#{Rails.root}/test/fixtures/apple_logo.jpg"), :website_id => websites(:standout).id)
    request.env["HTTP_REFERER"] = '/admin/pictures'

    post :destroy, :id => p.id
    assert_response :redirect
  end
  
end
