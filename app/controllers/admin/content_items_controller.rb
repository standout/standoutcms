class Admin::ContentItemsController < ApplicationController

  before_filter :check_login
  # TODO: Make sure we can only load contentitems that belongs to us.

  # GET /content_items
  # GET /content_items.xml
  def index
    @content_items = []
    respond_to do |format|
      format.html { render :layout => request.xhr? ? false : 'application' }
      format.xml  { render :xml => @content_items }
      format.json { @page = Page.find(params[:page_id]); render :json => @page.content_items.collect(&:for_html_id) }
    end
  end

  # GET /content_items/1
  # GET /content_items/1.xml
  def show
    if params[:dont_parse]
      render :text => ContentItem.find(params[:id]).text_content
    else
      @page = Page.find(params[:page_id])
      @content_items = @page.content_items.where(["for_html_id = ? and language = ?", params[:id], params[:language]])

      # Loading of fixed sized galleries.
      # We are creating a gallery and setting it to default settings here.
      if params[:imagesize]
        create_a_new_gallery
      end

      render :layout => false
    end
  end

  # GET /content_items/new
  # GET /content_items/new.xml
  def new
    @content_item = ContentItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @content_item }
    end
  end

  # POST /order/?div_id=shooosan
  #
  def order
    @content_items = ContentItem.where(["page_id = ? and for_html_id = ?", params[:page_id], params[:div_id]])
    # logger.info "#{params.inspect}"
    index = 0
    for div in params[:contentitems]
       logger.info "ID: #{div.inspect}"
      content_item = ContentItem.find(div)
      content_item.update_attribute :position, index
      index = index + 1
    end
    render :text => "ok"
  end


  # GET /content_items/1/edit
  def edit
    @content_item = ContentItem.find(params[:id])
    render :layout => false
  end

  # POST /content_items
  # POST /content_items.xml
  def create
    @content_item = ContentItem.new(content_item_params)
    if @content_item.save
      respond_to do |format|
        format.html { render :layout => false, :partial => 'content_item', :collection => [@content_item] }
        format.json { render :json => @content_item, :status => :created }
      end
    else
      respond_to do |format|
        format.html { render :text => 'problem!' }
        format.json { render :json => @content_item.errors, :status => :bad_request }
      end
    end
  end

  # PUT /content_items/1
  # PUT /content_items/1.xml
  def update
    @content_item = ContentItem.find(params[:id])
    if @content_item.update(content_item_params)
      Notice.create(:website_id => current_website.id, :user_id => current_user.id, :message => "updated page ##{@content_item.page_id} - #{@content_item.page.title}", :page_id => @content_item.page_id)
      @content_item.check_for_stickies
    end
    render :text => @content_item.content
  end

  # DELETE /content_items/1
  # DELETE /content_items/1.xml
  def destroy
    @content_item = ContentItem.find(params[:id])
    @content_item.destroy
    render :text => "Content item #{@content_item.id} was destroyed."
  end

  protected
  def create_a_new_gallery

    # Make sure we have one content item
    if @content_items.empty?
      @content_items = [ContentItem.create(:page_id => @page.id, :for_html_id => params[:id], :language => params[:language], :content_type => 'gallery')]
    end

    # See if there is an existing gallery. If not. create one.
    g = Gallery.find_by_content_item_id(@content_items.first.id)
    if g.blank?
      g = Gallery.new(:content_item_id => @content_items.first.id)
      g.liquid = File.read("#{Rails.root}/lib/liquid_templates/galleries/layoutimage.liquid")
    end

    # Always set the large image size from the Page Template
    g.large_size = params[:imagesize] + "#"
    g.save

  end

  private

  def content_item_params
    params.require(:content_item).permit %i(
      page_id
      for_html_id
      language
      content_type
      website_id
      width
      height
      text_content
      css
      original_filename
      position
      extra_id
      sticky
      deleted
      extra_view_id
      display_url
    )
  end
end
