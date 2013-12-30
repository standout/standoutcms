class Admin::CustomDataRowsController < ApplicationController
  
  before_filter :check_login
  before_filter :load_custom_data_list, :except => [:show]
  layout 'custom_data_lists'
  
  def load_custom_data_list
    @website = current_website
    @custom_data_list = @website.custom_data_lists.find(params[:custom_data_list_id])
  end
  
  def index
    @custom_data_rows = @custom_data_list.sorted_data_rows(true, params[:page].to_i == 0 ? 1 : params[:page])
    respond_to do |format|
      format.html
      format.json { render :json => @custom_data_rows.collect{ |c| CustomDataRowDrop.new(c) } }
    end
  end

  def show
    @custom_data_row = CustomDataRow.find(params[:id])
    render :layout => false
  end

  def new
    @custom_data_row = CustomDataRow.new(:custom_data_id => @custom_data_list.id)
  end

  def create
    
    render :text => "You need to specify parameter custom_data_row" and return false if params[:custom_data_row].nil? 
    
    @custom_data_row = CustomDataRow.new(:custom_data_id => params[:custom_data_row][:custom_data_id])
    @pictures = @files = []
    params[:custom_data_row].each do |key, value|
      if @custom_data_row.field_names.include?(key.to_s)
        # Is it an image?
        if @custom_data_row.fields.find_by_slug(key.to_s).fieldtype == 'image'
          
          pic = Picture.new
          # Check for http in image name, we want to download it from the model.
          if params[:custom_data_row][key.to_s.to_sym].is_a?(String) && params[:custom_data_row][key.to_s.to_sym].match('http')
            pic.image_url = params[:custom_data_row][key.to_s.to_sym] 
          else
            pic.data_content_type = params[:custom_data_row][key.to_s.to_sym].content_type
            pic.data_file_name = params[:custom_data_row][key.to_s.to_sym].original_filename
            pic.data = params[:custom_data_row][key.to_s.to_sym]
          end
          pic.custom_data_row_id = 0
          pic.custom_data_field_id = @custom_data_row.fields.find_by_slug(key.to_s).id
          pic.website_id = @website.id

          @custom_data_row.send("#{key}=", pic.url)
          @pictures << pic
        
        # Handle file uploads
        elsif @custom_data_row.fields.find_by_slug(key.to_s).fieldtype == 'file'
          file = AttachmentFile.new
          file.data_content_type = params[:custom_data_row][key.to_s.to_sym].content_type
          file.data_file_name = params[:custom_data_row][key.to_s.to_sym].original_filename
          file.title = params[:custom_data_row][key.to_s.to_sym].original_filename
          file.data = params[:custom_data_row][key.to_s.to_sym]
          file.website_id = @website.id
          file.custom_data_row_id = 0
          file.custom_data_field_id = @custom_data_row.fields.find_by_slug(key.to_s).id
          @custom_data_row.send("#{key}=", 1)
          @files << file
        else
          @custom_data_row.send("#{key}=", value)
          
        end
      else
        @custom_data_row.respond_to?(:"#{key}=") ? @custom_data_row.send(:"#{key}=", value) : raise("unknown attribute: #{key}")
      end
    end
    if @custom_data_row.save
      
      Notice.create(:user_id => current_user.id, :website_id => @website.id, :message => "added a new item to list #{@custom_data_row.custom_data_list.title}")
      
      
      # Save all attached images and files
      (@pictures + @files).each do |asset|
        asset.custom_data_row_id = @custom_data_row.id
        asset.save!
      end
      
      respond_to do |format|
        format.html { redirect_to [:admin, @custom_data_list, :custom_data_rows] }
        format.json { render :json => @custom_data_row.to_liquid, :status => :created }
      end
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.json { render :text => "Error", :status => :bad_request }
      end
    end
  
  #rescue => e
   # render :text => "Error: #{e.message}. <textarea>#{e.backtrace.join("\n")}</textarea>", :status => 500
  end

  def edit
    @custom_data_row = CustomDataRow.find(params[:id])
  end

  def update
    @custom_data_row = CustomDataRow.find(params[:id])
    params[:custom_data_row].each do |key, value|
      if @custom_data_row.field_names.include?(key.to_s)
         # Is it an image?
          if @custom_data_row.fields.find_by_slug(key.to_s).fieldtype == 'image'
            @pic = Picture.new
            logger.info "params[:custom_data_row][#{key.to_s.to_sym}] #{params[:custom_data_row][key.to_s.to_sym]}"
            @pic.custom_data_row_id = @custom_data_row.id
            @pic.website_id = @website.id
            @pic.data_content_type = params[:custom_data_row][key.to_s.to_sym].content_type
            @pic.data_file_name = params[:custom_data_row][key.to_s.to_sym].original_filename
            @pic.data = params[:custom_data_row][key.to_s.to_sym]
            @pic.custom_data_field_id = @custom_data_row.fields.find_by_slug(key.to_s).id
            @pic.save!
            @custom_data_row.send("#{key}=", @pic.url)
            # Handle file uploads
            elsif @custom_data_row.fields.find_by_slug(key.to_s).fieldtype == 'file'
              file = AttachmentFile.new
              file.data_content_type = params[:custom_data_row][key.to_s.to_sym].content_type
              file.data_file_name = params[:custom_data_row][key.to_s.to_sym].original_filename
              file.data = params[:custom_data_row][key.to_s.to_sym]
              file.website_id = @website.id
              file.custom_data_row_id = @custom_data_row.id
              file.custom_data_field_id = @custom_data_row.fields.find_by_slug(key.to_s).id
              file.save
              @custom_data_row.send("#{key}=", @custom_data_row.files_for(@custom_data_row.fields.find_by_name(key.to_s)).length)
          else
            @custom_data_row.send("#{key}=", value)
          end
      else
        @custom_data_row.respond_to?(:"#{key}=") ? @custom_data_row.send(:"#{key}=", value) : raise(UnknownAttributeError, "unknown attribute: #{key}")
      end
    end
    if @custom_data_row.save
      Notice.create(:user_id => current_user.id, :website_id => @website.id, :message => "updated item ##{@custom_data_row.id} from #{@custom_data_row.custom_data_list.title}")
      
			flash[:notice] = "Successfully updated custom data row."
			respond_to do |format|
				format.html { redirect_to [:admin, @custom_data_list, :custom_data_rows] }
				format.json { render :json => @custom_data_row, :status => :ok }
			end
    else
			respond_to do |format|
				format.html { render :action => :edit }
				format.json { render :json => @custom_data_row.errors, :status => :bad_request }
			end
    end
  end

  def destroy
    @custom_data_row = @custom_data_list.custom_data_rows.find(params[:id])
    Notice.create(:user_id => current_user.id, :website_id => @website.id, :message => "removed item ##{@custom_data_row.id} from #{@custom_data_row.custom_data_list.title}")
    @custom_data_row.destroy
    flash[:notice] = "Successfully destroyed custom data row."
    redirect_to [:admin, @custom_data_list, :custom_data_rows]
  end
  
  protected
  
  def save_the_file(custom_data_row, data)
    filename = sanitize_filename(data.original_filename)
    path = "#{Rails.root}/public/#{custom_data_row.directory}/"
    FileUtils.mkdir_p path
    File.open(path + filename, "wb") do |f| 
      f.write(data.read)
    end
    look_file.filename = sanitize_filename(data.original_filename)
    look_file.content_type = data.content_type
    look_file.save
  end
  
  def sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name) 
    # replace all none alphanumeric, underscore or perioids with underscore
    just_filename.sub(/[^\w\.\-]/,'_').downcase 
  end
  
end
