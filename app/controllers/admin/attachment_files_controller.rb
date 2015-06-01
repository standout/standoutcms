class Admin::AttachmentFilesController < ApplicationController
  before_filter :load_website

  def index
    @custom_data_list = @website.custom_data_lists.find(params[:custom_data_list_id])
    @custom_data_row = @custom_data_list.custom_data_rows.find(params[:custom_data_row_id])
  end

  def create
    @attachment_file = AttachmentFile.new(attachment_file_params)
    @attachment_file.website_id = @website.id
    if @attachment_file.save
      redirect_to :back
    end
  end

  def show
    @picture = AttachmentFile.find(params[:id])
  end

  def update
    @custom_data_list = @website.custom_data_lists.find(params[:custom_data_list_id])
    @custom_data_row = @custom_data_list.custom_data_rows.find(params[:custom_data_row_id])
    @attachment_file = @custom_data_row.attachment_files.find(params[:id])
    @attachment_file.update(attachment_file_params)
    render :text => 'Attachment File updated.'
  end

  def destroy
    if params[:custom_data_list_id]
      @custom_data_list = @website.custom_data_lists.find(params[:custom_data_list_id])
      @custom_data_row = @custom_data_list.custom_data_rows.find(params[:custom_data_row_id])
      parent = @custom_data_row
    end

    if params[:product_category_id]
      parent = @website.product_categories.find(params[:product_category_id])
    end

    parent ||= @website

    @attachment_file = parent.attachment_files.find(params[:id])

    if @attachment_file.destroy
      @custom_data_row.save if @custom_data_row
      flash[:notice] = "File was deleted."
    else
      flash[:error] = "Could not delete file. Sorry."
    end
    redirect_to :back
  end

  def load_website
    if current_user.admin?
      @website = current_website
    else
      @website = current_user.websites.find(current_website.id)
    end
  end

  private

  def attachment_file_params
    params.require(:attachment_file).permit %i(
      data
    )
  end
end
