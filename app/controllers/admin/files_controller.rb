class Admin::FilesController < ApplicationController

  before_filter :check_login

  def index
    @files = AttachmentFile.where(:website_id => current_website).order("id DESC")
  end

  def create
    @file = AttachmentFile.new(attachment_file_params)
    @file.website_id = current_website.id
    if @file.save
      redirect_to :back
    else
      render :action => 'new'
    end
  end

  def destroy
    @file = current_website.assets.find(params[:id])
    @file.destroy
    redirect_to [:admin, :files]
  end

  private

  def attachment_file_params
    params.require(:attachment_file).permit *%i(
      data
    )
  end
end
