class Admin::CustomDataFieldsController < ApplicationController
  
  before_filter :check_login
  before_filter :load_website_and_custom_data_list
  layout 'custom_data_lists'
  
  def index
    @custom_data_fields = @custom_data_list.custom_data_fields
  end

  def show
    @custom_data_field = CustomDataField.find(params[:id])
  end

  def new
    @custom_data_field = CustomDataField.new
  end

  def create
    @custom_data_field = CustomDataField.new(custom_data_field_params)
    @custom_data_field.custom_data_id = @custom_data_list.id
    if @custom_data_field.save
      flash[:notice] = "Successfully created custom data field."
      redirect_to [:edit, :admin, @custom_data_list]
    else
      render :action => 'new'
    end
  end

  def edit
    @custom_data_field = @custom_data_list.custom_data_fields.find(params[:id])
  end

  def update
    @custom_data_field = @custom_data_list.custom_data_fields.find(params[:id])
    @custom_data_field.custom_data_id = @custom_data_list.id
    if @custom_data_field.update(custom_data_field_params)
      flash[:notice] = "Successfully updated custom data field."
      redirect_to [:edit, :admin, @custom_data_list]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @custom_data_field = CustomDataField.find(params[:id])
    @custom_data_field.destroy
    flash[:notice] = "Successfully destroyed custom data field."
    redirect_to [:edit, :admin, @custom_data_list]
  end
  
  protected
  def load_website_and_custom_data_list
    @website = current_website
    @custom_data_list = @website.custom_data_lists.find(params[:custom_data_list_id])    
  end

  private

  def custom_data_field_params
    params.require(:custom_data_field).permit %i(
      name
      fieldtype
      custom_data_id
      display_in_list
      image_size_large
      image_size_medium
      image_size_small
      listconnection
    )
  end
end
