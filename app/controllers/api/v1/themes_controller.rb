class Api::V1::ThemesController < Api::V1::BaseController

  before_filter :authorize

  def authorize
    @website = Website.find_by_api_key_and_subdomain(params[:api_key], params[:subdomain])
    render :text => "Not allowed", :status => 403 and return false if @website.blank?
  end

  def index
    render :json => @website.looks.to_json()
  end

  def show
    @look = @website.looks.find(params[:id])
    render :json => {
      :id => @look.id,
      :files => @look.look_files.to_json,
      :page_templates => @look.page_templates.to_json
    }
  end

end