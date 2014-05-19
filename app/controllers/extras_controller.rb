class ExtrasController < ApplicationController

  # POST /websites/1/extras/2/install
  def install
    @website ||= Website.find(params[:website_id])
    @website.extras << Extra.find(params[:id])
    render :update do |page|
      page.alert "Plugin installed!"
      page.replace :installed_plugins, :partial => "extras/installed"
    end
  end

  # GET /extras
  # GET /extras.xml
  def index
    @extras = Extra.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @extras }
    end
  end

  # GET /extras/1
  # GET /extras/1.xml
  def show
    @extra = Extra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @extra }
    end
    render :layout => false
  end

  # GET /extras/new
  # GET /extras/new.xml
  def new
    @extra = Extra.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @extra }
    end
  end

  # GET /extras/1/edit
  def edit
    @extra = Extra.find(params[:id])
  end
  
  def settings
    @content_item = ContentItem.find(params[:id])
    if @content_item.extra_id
      @extra = Extra.find(@content_item.extra_id) 
    else
      @extra = Extra.create(:website_id => current_website_id)
      @content_item.update_attribute :extra_id, @extra.id
    end
    render :layout => false
  end

  # POST /extras
  # POST /extras.xml
  def create
    @extra = Extra.new(extra_params)

    respond_to do |format|
      if @extra.save
        flash[:notice] = 'Extra was successfully created.'
        format.html { redirect_to(@extra) }
        format.xml  { render :xml => @extra, :status => :created, :location => @extra }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @extra.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /extras/1
  # PUT /extras/1.xml
  def update
    @extra = Extra.find(params[:id])

    respond_to do |format|
      if @extra.update(extra_params)
        flash[:notice] = 'Extra was successfully updated.'
        format.html { redirect_to(@extra) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @extra.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /extras/1
  # DELETE /extras/1.xml
  def destroy
    @extra = Extra.find(params[:id])
    @extra.destroy

    respond_to do |format|
      format.html { redirect_to(extras_url) }
      format.xml  { head :ok }
    end
  end

  private

  def extra_params
    params.require(:extra).permit %i(
      name
      edit_url
      public
      website_id
      display_url
    )
  end
end
