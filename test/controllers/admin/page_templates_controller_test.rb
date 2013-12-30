require 'test_helper'

class Admin::PageTemplatesControllerTest < ActionController::TestCase

  def setup
    request.host = "standout.standoutcms.dev"
    @controller = Admin::PageTemplatesController.new
    session[:user_id] = users(:david).id
    @look = websites(:standout).looks.first
  end

  test 'creating and destroying a page template should create a notice' do
    number_of_notices = websites(:standout).notices.size
    post :create, { :look_id => @look.id, :page_template => { :name => 'New template' }}
    assert_response :redirect
    assert_equal websites(:standout).reload.notices.size, number_of_notices + 1
    post :destroy, { :look_id => @look.id, :id => websites(:standout).page_templates.last.id }
    assert_response :redirect
    assert_equal websites(:standout).reload.notices.size, number_of_notices + 2
  end

  test 'editing a page template should create a notice' do
    page_template = websites(:standout).looks.first.page_templates.first
    number_of_notices = websites(:standout).notices.size
    post :update, { :id => page_template.id, :look_id => @look.id, :page_template => { :name => 'Changed name', :html => 'Other html' }}
    assert_response :redirect
    assert_equal websites(:standout).reload.notices.size, number_of_notices + 1
  end

end
