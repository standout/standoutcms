require 'test_helper'
class Admin::WebsiteMembershipsControllerTest < ActionController::TestCase

  setup do
    @controller = Admin::WebsiteMembershipsController.new
    request.host = 'standout.test.host'
    login_as :david
  end

  test 'can get a list of users with access to this website' do
    get :index, format: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal users(:david).email, json[0]['email'], "#{json}"
  end

  test 'can add a website membership' do
    assert_difference 'WebsiteMembership.count' do
      post :create, website_membership: { email: 'newman@example.com' }
    end
    assert_response :success
  end

  test 'can delete a website membership' do
    assert_difference 'WebsiteMembership.count', -1 do
      delete :destroy, id: WebsiteMembership.first.id
    end
    assert_response :success
  end

end
