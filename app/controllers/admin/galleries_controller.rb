class Admin::GalleriesController < ApplicationController
  
  before_filter :check_login
  
  # GET /galleries/1
  # GET /galleries/1.xml
  def show
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /galleries/new
  # GET /galleries/new.xml
  def new
    @gallery = Gallery.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /galleries/1/edit
  def edit
    @gallery = Gallery.find_or_create_by_content_item_id(params[:id])
    render :layout => false #if request.xhr?
  end

  # POST /galleries
  # POST /galleries.xml
  def create
    @gallery = Gallery.new(params[:gallery])
    @gallery.website_id = session[:website_id]
    respond_to do |format|
      if @gallery.save
        flash[:notice] = 'Gallery was successfully created.'
        format.html { redirect_to([:admin, @gallery]) }
        format.xml  { render :xml => @gallery, :status => :created, :location => @gallery }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
    
  end

  # PUT /galleries/1
  # PUT /galleries/1.xml
  def update
    @gallery = Gallery.find(params[:id])
    @gallery.update_attributes(params[:gallery])
    responds_to_parent do
      render :update do |page|
        page.replace_html "gallery_title", @gallery.title
        page.visual_effect :fade, "edit_gallery_form"
      end
    end
  end

  # DELETE /galleries/1
  # DELETE /galleries/1.xml
  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy

    respond_to do |format|
      format.html { redirect_to(galleries_url) }
      format.xml  { head :ok }
    end
  end
  
  def copy_from_other_gallery
    @this_gallery = Gallery.find(params[:id])
    @other_gallery = Gallery.find(params[:other_gallery])
    
    for photo in @other_gallery.gallery_photos
      photo.copy_to(@this_gallery)
    end
    render :text => "ok"
  end
  
end
