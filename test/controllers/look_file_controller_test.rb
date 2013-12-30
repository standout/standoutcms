require 'test_helper'

class LookFileControllerTest < ActionController::TestCase

  def setup
    request.host = "standout.standoutcms.dev"
    @controller = Admin::LookFilesController.new
    session[:user_id] = users(:david).id
    @website = websites(:standout)
    @look = looks(:standout_look)
  end

  test 'should accept latin1-encoded files' do
    text_in_latin = "#{Rails.root}/test/controllers/look_file_controller_test/latin1.css"
    file = Rack::Test::UploadedFile.new(text_in_latin, "text/plain")
    post :create, :look_file => { }, :look_id => looks(:standout_look).id, :uploaded_data => file
    assert_response :redirect
    assert_equal(flash[:notice], I18n.t('notices.look_file.created'))
  end

end