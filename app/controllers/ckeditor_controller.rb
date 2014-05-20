class CkeditorController < ApplicationController
  
#  before_filter :swf_options, :only=>[:images, :files, :create]
  before_filter :load_website
  layout "ckeditor"
  
  def load_website
    @website = current_website
  end
  
  # GET /ckeditor/images
  def images
    @images = @website.assets.where(:type => 'Picture').order("created_at desc")
    
    respond_to do |format|
      format.html {}
      format.xml { render :xml=>@images }
    end
  end
  
  def image
    @image = Picture.find(params[:id])
    if @image.processing? # && Rails.env.development?
      logger.info "Working off some DJ:s"
      Delayed::Job.work_off
    end
    render :partial => 'image', :object => @image
  end
  
  # GET /ckeditor/files
  def files
    @files = AttachmentFile.where(:website_id => @website.id).order("id DESC")
    
    respond_to do |format|
      format.html {}
      format.xml { render :xml=>@files }
    end
  end

  def destroy
    @kind = params[:kind] ||= 'file'
    @record = case @kind.downcase
      when 'file'  then AttachmentFile.find(params[:id])
			when 'image' then Picture.find(params[:id])
	  end  
	  if session[:website_id] == @record.website_id
	    @record.destroy
    end
	  redirect_to :back
	  
  end
  
  # POST /ckeditor/create
  def create
    
    @kind = params[:kind] || 'file'
    
    @record = case @kind.downcase
      when 'file'  then AttachmentFile.new
			when 'image' then Picture.new
	  end
	  
	  unless params[:CKEditor].blank?	  
	    params[@swf_file_post_name] = params.delete(:upload)      
	  end
	  
	  options = {}
	  
	  params.each do |k, v|
	    key = k.to_s.downcase
	    options[key] = v if @record.respond_to?("#{key}=")
	  end
    
    @record.attributes = options
    @record.website_id = session[:website_id] #.gsub('\\00', '') # don't know why it is sent as \00x where x is website number.
    
    if @record.valid? && @record.save
	    render :text => "finished"
    end
  end

  # private
  #   
  #   def swf_options
  #     if Ckeditor::Config.exists?
  #       @swf_file_post_name = Ckeditor::Config['swf_file_post_name']
  #       
  #       if params[:action] == 'images'
  #         @file_size_limit = Ckeditor::Config['swf_image_file_size_limit']
  #           @file_types = Ckeditor::Config['swf_image_file_types']
  #           @file_types_description = Ckeditor::Config['swf_image_file_types_description']
  #           @file_upload_limit = Ckeditor::Config['swf_image_file_upload_limit']
  #         else
  #           @file_size_limit = Ckeditor::Config['swf_file_size_limit']
  #           @file_types = Ckeditor::Config['swf_file_types']
  #           @file_types_description = Ckeditor::Config['swf_file_types_description']
  #           @file_upload_limit = Ckeditor::Config['swf_file_upload_limit']
  #         end
  #     end
  #     
  #     @swf_file_post_name ||= 'data'
  #     @file_size_limit ||= "5 MB"
  #     @file_types ||= "*.jpg;*.jpeg;*.png;*.gif"
  #     @file_types_description ||= "Images"
  #     @file_upload_limit ||= 10
  #   end
  #   
    def escape_single_quotes(str)
      str.gsub('\\','\0\0').gsub('</','<\/').gsub(/\r\n|\n|\r/, "\\n").gsub(/["']/) { |m| "\\#{m}" }
    end
    
  
end
