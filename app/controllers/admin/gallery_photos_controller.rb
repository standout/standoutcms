class Admin::GalleryPhotosController < ApplicationController

  before_filter :check_login
  # GET /gallery_photos
  # GET /gallery_photos.xml
  def index
    @gallery_photos = Gallery.find(params[:gallery_id]).
      gallery_photos.order("position")

    respond_to do |format|
      format.html {
          render :layout => false
      }
      format.xml  { render :xml => @gallery_photos }
    end
  end
  # POST /admin/gallery_photos/sort?gallery_id=1
  def sort
    gallery_photos = Gallery.find(params[:gallery_id]).gallery_photos
    params[:gallery_photo].each_with_index do |id, index|
      gallery_photos.update_all({position: index + 1}, {id: id})
    end
    render nothing: true
  end

  # GET /gallery_photos/1
  # GET /gallery_photos/1.xml
  def show
    @gallery_photo = GalleryPhoto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gallery_photo }
    end
  end

  # GET /gallery_photos/new
  # GET /gallery_photos/new.xml
  def new
    @gallery_photo = GalleryPhoto.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gallery_photo }
    end
  end

  # GET /gallery_photos/1/edit
  def edit
    @gallery_photo = GalleryPhoto.find(params[:id])
  end

  # POST /gallery_photos
  # POST /gallery_photos.xml
  def create
    params[:gallery_photo][:photo].each do |photo|
      @gallery_photo = GalleryPhoto.new()
      @gallery_photo.gallery = Gallery.find(params[:gallery_photo][:gallery_id]) # we need to set this before.
      @gallery_photo.photo = photo
      @gallery_photo.save
    end
  end

  # PUT /gallery_photos/1
  # PUT /gallery_photos/1.xml
  def update
    @gallery_photo = GalleryPhoto.find(params[:id])

    respond_to do |format|
      if @gallery_photo.update(gallery_photo_params)
        format.html { render :text => "GalleryPhoto updated." }
        format.xml  { head :ok }
      else
        format.html { render :text => "GalleryPhoto not updated." }
        format.xml  { render :xml => @gallery_photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gallery_photos/1
  # DELETE /gallery_photos/1.xml
  def destroy
    @gallery_photo = GalleryPhoto.find(params[:id])
    @gallery_photo.destroy
    respond_to do |format|
      format.html { render :text => 'Photo deleted.' }
      format.js
    end
  end

  def order
    # TODO: fix ordering
    render :nothing => true
  end

  private

  def gallery_photo_params
    params.require(:gallery_photo).permit %i(
      gallery_id
      filename
      position
      caption
      content_type
      photo
    )
  end

end
