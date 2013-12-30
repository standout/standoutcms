require 'test_helper'

class Api::V1::CustomDataRowsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::CustomDataRowsController.new
    @request.host = 'api.standoutcms.dev'

    @custom_data_list = CustomDataList.create!(:website_id => websites(:standout).id)

    @custom_data_list.custom_data_fields.create!(
      name: 'first_name', fieldtype: 'string'
    )
    @custom_data_list.custom_data_fields.create!(
      name: 'last_name', fieldtype: 'string'
    )
    assert @custom_data_list.custom_data_fields.size > 0
    @custom_data_row = CustomDataRow.new(custom_data_id: @custom_data_list.id)
    @custom_data_row.first_name = 'Lorem'
    @custom_data_row.last_name = 'Ipsum'
    @custom_data_row.slug = 'loremipsumtesting'
    @custom_data_row.save!
  end

  test 'index should return all rows for the current list' do
    get :index, format: :json, custom_data_list_id: @custom_data_list.id
    assert_response :success
    assert_equal @response.body, @custom_data_list.custom_data_rows.to_json
  end

  test 'show should return the current row' do
    get(:show,
      format: :json,
      custom_data_list_id: @custom_data_list.id,
      id: @custom_data_row.id
    )
    assert_response :success
    assert_equal @response.body, @custom_data_row.to_json
  end

  test 'index should return url for custom data rows' do
    get :index, format: :json, custom_data_list_id: @custom_data_list.id
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal "loremipsumtesting", json.last['slug']
    assert_equal "http://standout.se/loremipsumtesting", json.last['url']
  end

  test 'connection between lists should be rendered correctly on form' do
    @controller = Admin::CustomDataRowsController.new
    @request.host = 'standout.standoutcms.dev'
    login_as(:david)
    @custom_data_list.custom_data_fields.create!(
      name: 'testconnection', fieldtype: 'listconnections', listconnection: CustomDataList.first.id
    )
    get :new, custom_data_list_id: @custom_data_list.id
    assert_response :success
  end

end
