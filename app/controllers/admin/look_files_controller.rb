class Admin::LookFilesController < ApplicationController

  before_filter :check_login
  before_filter :load_look_and_website
  layout 'admin/looks'

  def load_look_and_website
    @website = current_website
    @look = @website.looks.find(params[:look_id])
  end

  # GET /look_files
  # GET /look_files.xml
  def index
    redirect_to [:edit, @website, @look]
  end

  # GET /look_files/1
  # GET /look_files/1.xml
  def show
    @look_file = LookFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @look_file }
    end
  end

  # GET /look_files/new
  # GET /look_files/new.xml
  def new
    @look_file = LookFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @look_file }
    end
  end

  # GET /look_files/1/edit
  def edit
    @look_file = LookFile.find(params[:id])
  end

  # POST /look_files
  # POST /look_files.xml
  def create
    @look_file = LookFile.new(look_file_params)
    @look_file.look_id = @look.id

    respond_to do |format|
      if @look_file.save && params[:uploaded_data]
        save_the_file(@look_file, params[:uploaded_data])
        flash[:notice] = I18n.t('notices.look_file.created')
        format.html { redirect_to([:edit, :admin, @look]) }
        format.xml  { render :xml => @look_file, :status => :created, :location => @look_file }
        format.js do
          responds_to_parent do
            render :update do |page|
              page.insert_html :bottom, "template_files", render(:partial => "look_files/file", :object => @look_file)
              page.replace_html "number_of_looks_files", @look_file.look.look_files.length.to_s
              page['looks_files_upload_form'].reset
            end # render
          end # responds_to_parent
        end # wants
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @look_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /look_files/1
  # PUT /look_files/1.xml
  # Remember: when we are updating a file we are only replacing the data, not any other parameters.
  def update
    @look_file = @look.look_files.find(params[:id])

    respond_to do |format|

      # The files need to be of the same content type.
      if params[:uploaded_data] # && params[:uploaded_data].content_type == @look_file.content_type
        @look_file.remove_file
        save_the_file(@look_file, params[:uploaded_data], true)
      else
        @look_file.update(look_file_params)
      end

      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end

  # DELETE /look_files/1
  # DELETE /look_files/1.xml
  def destroy
    @look_file = LookFile.find(params[:id])
    @look_file.destroy

    respond_to do |format|
      format.html { redirect_to([:edit, :admin, @look]) }
      format.xml  { head :ok }
    end
  end

  protected
  def save_the_file(look_file, data, replace = false)

    unless data.nil?
      look_file.filename = sanitize_filename(data.original_filename) unless replace

      path = "#{Rails.root}/public/#{look_file.directory}/"

      FileUtils.mkdir_p path
      File.open(path + look_file.filename, "wb") do |f|
        f.write(data.read)
      end
      look_file.filename = filename if look_file.filename.nil?
      look_file.content_type = data.content_type if look_file.content_type.nil?
      look_file.save
    end
  end

  def sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name)
    # replace all none alphanumeric, underscore or perioids with underscore
    just_filename.sub(/[^\w\.\-]/,'_').downcase
  end

  private

  def look_file_params
    return {} unless params[:look_file]
    params.require(:look_file).permit(
      :content_type,
      :filename,
      :text_content
    )
  end
end
