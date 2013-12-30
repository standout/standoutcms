require 'test_helper'
class VendorControllerTest < ActionController::TestCase

  def setup
    @controller = VendorsController.new
    request.host = "standout.standoutcms.dev"
  end

end