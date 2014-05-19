class Admin::LooksController < ApplicationController
  
  before_filter :check_login
  before_filter :load_website
  
  def load_website
    if current_user.admin?
      @website = current_website
    else
      @website = current_user.websites.find(current_website.id)
    end
  end
  
  # GET /looks
  # GET /looks.xml
  def index
    @looks = @website.looks
     
    respond_to do |format|
       format.html { }
       format.xml  { render :xml => @looks }
     end
  end
  
  # GET /looks/1
  # GET /looks/1.xml
  def show
    @look = Look.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @look }
    end
  end
  
  # POST /looks/install/1
  def install
    @look = Look.find(params[:id])
    @new_look = Look.new(@look.attributes)
    @new_look.website_id = session[:website_id]
    @new_look.shared = false
    @new_look.save
    @look.copy_files_to(@new_look)
    render :update do |page|
      page.insert_html :bottom, "looks_list", :partial => "looks/look", :collection => [@new_look]
      page.visual_effect :highlight, "look_#{@new_look.id}"
      page.visual_effect :fade, "template_gallery"
    end
  end

  # GET /looks/new
  # GET /looks/new.xml
  def new
    @look = Look.new(:website_id => @website.id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @look }
    end
  end

  # GET /looks/1/edit
  def edit
    @look = Look.find(params[:id])
    if request.xhr?
      render :layout => false
    end
  end

  # POST /looks
  # POST /looks.xml
  # TODO: Fix the whole creation of looks.
  def create
    @look = Look.new(params[:look])
    @look.website_id = @website.id
    if @look.save
      flash[:notice] = t('added_theme')
      redirect_to [:edit, :admin, @look]
    else
      render :action => 'new'
    end
  end

  # PUT /looks/1
  # PUT /looks/1.xml
  def update
    @look = Look.find(params[:id])

    respond_to do |format|
      if @look.update(look_params)
        format.html { redirect_to(@look) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @look.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /looks/1
  # DELETE /looks/1.xml
  def destroy
    @look = Look.find(params[:id])
    @look.destroy

    respond_to do |format|
      format.html { redirect_to(looks_url) }
      format.xml  { head :ok }
      format.js {
        render
      }
    end
  end

  private

  def look_params
    params.require(:look).permit %i(
      title
      html
      shared
      blogentry
    )
  end
end
