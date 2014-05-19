class MenuController < ApplicationController

  before_filter :check_login

  def edit
    @page = Page.find(params[:page_template_id])
    @menu = Menu.find(:first, :conditions => ["for_html_id = ? and page_template_id = ?", params[:div_id], @page.page_template_id])
    render :layout => false
  end

  def update
    @menu = Menu.find(params[:id])
    if @menu.update(menu_params)
      render :text => "Menu item #{@menu.id} updated."
    end
  end

  private

  def menu_params
    params.require(:).permit %i(
      look_id
      for_html_id
      levels
      start_level
      show_submenus
      page_template_id
    )
  end

end
