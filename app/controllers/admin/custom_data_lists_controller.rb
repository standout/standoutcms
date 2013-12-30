class Admin::CustomDataListsController < ApplicationController

  before_filter :check_login
  before_filter :load_website

  def index
    @custom_data_lists = @website.custom_data_lists
  end

  def show
    @custom_data_list = CustomDataList.find(params[:id])
  end

  def new
    @custom_data_list = CustomDataList.new(:website_id => @website.id)
  end

  def create
    @custom_data_list = CustomDataList.new(params[:custom_data_list])
    if @custom_data_list.save
      Notice.create(:website_id => @website.id, :user_id => current_user.id, :message => "created list ##{@custom_data_list.id} - #{@custom_data_list.title}")
      flash[:notice] = "Successfully created custom data."
      redirect_to [:edit, :admin, @custom_data_list]
    else
      render :action => 'new'
    end
  end

  def edit
    @custom_data_list = @website.custom_data_lists.find(params[:id])
    @custom_data_field = CustomDataField.new(:custom_data_id => @custom_data_list.id)
  end

  def update
    @custom_data_list = CustomDataList.find(params[:id])
    if @custom_data_list.update_attributes(params[:custom_data_list])
      Notice.create(:website_id => @website.id, :user_id => current_user.id, :message => "updated settings of list ##{@custom_data_list.id} - #{@custom_data_list.title}")
      flash[:notice] = "Successfully updated list."
      redirect_to [:edit, :admin, @custom_data_list]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @custom_data_list = CustomDataList.find(params[:id])
    Notice.create(:website_id => @website.id, :user_id => current_user.id, :message => "deleted list ##{@custom_data_list.id} - #{@custom_data_list.title}")
    @custom_data_list.destroy
    flash[:notice] = "Successfully destroyed list."
    redirect_to [:admin, :custom_data_lists]
  end


  protected
  def load_website
    @website = current_website
  end
end
