class BlogSettingsController < ApplicationController

  # GET /blog_settings/1
  # GET /blog_settings/1.xml
  def show
    @blog_setting = BlogSetting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog_setting }
    end
  end

  # GET /blog_settings/new
  # GET /blog_settings/new.xml
  def new
    @blog_setting = BlogSetting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog_setting }
    end
  end

  # GET /blog_settings/1/edit
  def edit
    @blog_setting = BlogSetting.find(params[:id])
  end

  # POST /blog_settings
  # POST /blog_settings.xml
  def create
    @blog_setting = BlogSetting.new(params[:blog_setting])

    respond_to do |format|
      if @blog_setting.save
        flash[:notice] = 'BlogSetting was successfully created.'
        format.html { redirect_to(@blog_setting) }
        format.xml  { render :xml => @blog_setting, :status => :created, :location => @blog_setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blog_settings/1
  # PUT /blog_settings/1.xml
  def update
    @blog_setting = BlogSetting.find(params[:id])

    respond_to do |format|
      if @blog_setting.update_attributes(params[:blog_setting])
        flash[:notice] = 'BlogSetting was successfully updated.'
        format.html { redirect_to(@blog_setting) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_settings/1
  # DELETE /blog_settings/1.xml
  def destroy
    @blog_setting = BlogSetting.find(params[:id])
    @blog_setting.destroy

    respond_to do |format|
      format.html { redirect_to(blog_settings_url) }
      format.xml  { head :ok }
    end
  end
end
