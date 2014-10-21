require 'test_helper'
class Admin::VendorsControllerTest < ActionController::TestCase

  def setup
    request.host = "standout.standoutcms.dev"
  end

end
