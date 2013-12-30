class SearchController < ApplicationController

  def index
    @website = current_website
    page_template = @website.page_templates.where(:slug => 'search').first
    if page_template.nil?
      render :text => "You need a page template called search to display search results.", :status => :not_implemented
    else
      render :text => render_the_template(@website, page_template, current_cart, { :query => params[:q].to_s })
    end
  end

end