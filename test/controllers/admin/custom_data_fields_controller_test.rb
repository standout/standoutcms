require 'test_helper'

class Admin::CustomDataFieldsControllerTest < ActionController::TestCase

  def setup
    @controller = Admin::CustomDataFieldsController.new
    request.host = "standout.standoutcms.dev"
  end

  test 'should be able to change a custom data field' do
    session[:user_id] = users(:david).id
    # Kind of awkward setup and save since the fixtures does not 
    # support having different table names (CustomDataList (model) vs custom_datas (table))
    cdl = CustomDataList.first
    cdf = custom_data_fields(:first_cdf)
    cdf.custom_data_id = cdl.id
    cdl.website_id = Website.find_by_subdomain('standout').id
    cdl.save
    cdf.save
    put :update, id: cdf.id,
      custom_data_list_id: cdl.id,
      custom_data_field: { name: 'Something else' }
    assert_response :redirect
  end
  
end
