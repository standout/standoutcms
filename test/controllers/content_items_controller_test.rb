require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase

  def setup
    @controller = Admin::ContentItemsController.new
    request.host = "standout.standoutcms.dev"
  end

  test 'should be able to add a new content item' do
    session[:user_id] = users(:david).id
    page = pages(:standout_secondpage)
    post :create, {"content_item"=>{"page_id"=> page.id, "for_html_id"=>"content", "language"=>"sv", "content_type"=>"liquid"}}
    assert_response :success
  end

end
