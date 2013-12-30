class AllowedPagesController < ApplicationController

  def create
    @allowed_page = AllowedPage.new(params[:allowed_page])
    @allowed_page.save
    render :partial => 'pages/page_editor', :locals => { :page => @allowed_page.page }
  end

  def destroy
    @allowed_page = AllowedPage.find(params[:id])
    @page = @allowed_page.page
    @allowed_page.destroy
    render :partial => 'pages/page_editor', :locals => { :page => @page }
  end

end