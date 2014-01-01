class Api::V1::CustomDataRowsController < Api::V1::BaseController
  before_filter :find_custom_data_list

  def index
    @custom_data_rows = @custom_data_list.custom_data_rows
    render json: @custom_data_rows.to_json
  end

  def show
    @custom_data_row = @custom_data_list.custom_data_rows.find(params[:id])
    render json: @custom_data_row.to_json
  end

  # Finds the current CustomDataList from the path. This is not necessary on
  # single CustomDataRows (like in #show), but it is the most RESTful and future
  # proof approach.
  def find_custom_data_list
    @custom_data_list = CustomDataList.find(params[:custom_data_list_id])
  end
end
