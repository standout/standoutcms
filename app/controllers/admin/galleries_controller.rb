class Admin::GalleriesController < ApplicationController
  before_filter :check_login
  layout "admin/responsive"
  respond_to :html, :json

  # GET /galleries/1
  # GET /galleries/1.xml
  def show
    @gallery = current_website.galleries.find(params[:id])

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
    @gallery = current_website.galleries.find(params[:id])
    @page = @gallery.content_item.page
  end

  # POST /galleries
  # POST /galleries.xml
  def create
    @gallery = Gallery.new(gallery_params)
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
    @gallery.update(gallery_params)
    respond_with :admin, @gallery, location: edit_admin_gallery_path(@gallery)
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

  private

  def gallery_params
    params.require(:gallery).permit %i(
      content_item_id
      title
      overview_file_name
      overview_content_type
      overview_file_size
      overview_updated_at
      liquid
      thumbnail_size
      large_size
    )
  end

end
