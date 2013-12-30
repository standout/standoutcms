class MenuController < ApplicationController
  
  before_filter :check_login

  def edit
    @page = Page.find(params[:page_template_id])
    @menu = Menu.find(:first, :conditions => ["for_html_id = ? and page_template_id = ?", params[:div_id], @page.page_template_id])
    render :layout => false
  end

  def update
    @menu = Menu.find(params[:id])
    if @menu.update_attributes(params[:menu])
      render :text => "Menu item #{@menu.id} updated."
    end
  end

end
