class Admin::PagesController < ApplicationController

  before_filter :check_login
  before_filter :load_website, :only => [:index, :show, :update]

  def load_website
    @website = current_website
  end

  # GET /pages
  # GET /pages.xml
  def index
    @pages = @website.pages
    @notices = @website.notices.limit(30)

    respond_to do |format|
      format.html { }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  # TODO: Remove completely?
  def show
    @page = @website.pages.find(params[:id])
    unless current_user.can_edit?(@page)
      flash[:notice] = t('no_rights_to_edit_page')
      redirect_to [:admin, :pages] 
    end
  end

  def details
    @page = Page.find(params[:id])
    render :partial => 'details', :collection => [@page]
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
    render :layout => false
  end
  
  def preview
    @page = Page.find(params[:id])
    render :text => @page.complete_html(params[:language].to_s)
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(page_params)
    @website = current_website
    respond_to do |format|
      if @page.save
        Notice.create(:user_id => current_user.id, :website_id => current_website.id, :page_id => @page.id, :message => "created a new page")
        format.html { redirect_to([:admin, @page]) }
        format.js { render :partial => 'pages/page', :collection => @page.website.root_pages }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = @website.pages.find(params[:id])

    respond_to do |format|
      if @page.update(page_params)
        Notice.create(:user_id => current_user.id, :website_id => current_website.id, :page_id => @page.id, :message => "updated page")
        
        format.html { render :partial => 'admin/pages/page', :collection => @page.website.root_pages }
        format.xml  { head :ok }
        format.js { render :partial => 'admin/pages/page', :collection => @page.website.root_pages }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    
    Notice.create(:user_id => current_user.id, :website_id => current_website.id, :page_id => @page.id, :message => "deleted page")
    
    
    @page.destroy

    respond_to do |format|
      format.html { redirect_to([:admin, :pages]) }
      format.xml  { head :ok }
      format.js { render :partial => 'admin/pages/page', :collection => @page.website.root_pages }
    end
  end

  # For use with the menu editor in content view
  # TODO: move this to a more appropriate location?
  def menu_items
    @page = Page.find(params[:id])
    @language = params[:language]
    @parent_ids = @page.all_parent_ids 

    # Find or create the menu item. We need this to store settings for a menu.  
    @menu = Menu.find_or_create_by_page_template_id_and_for_html_id(@page.page_template_id, params[:div_id])
    
    # If we have parameters from the menu page and nothing is set
    @number_of_submenus = 0
    if params[:sublevels] && params[:sublevels] != 'undefined'
      @menu.levels = params[:sublevels].to_i
      @menu.start_level = params[:startlevel].to_i
      @menu.save
    end

    # Return pages based on settings in the menu item
    if @menu.start_level == 0
      @pages = current_website.root_pages
    else
      # We are starting lower in the tree. Return all pages in the tree and down to the correct level.
      pages = Page.find(:all, :conditions => ["website_id = ? and level = ?", params[:website_id], @menu.start_level])
      # logger.info(@menu.to_yaml)
      for page in pages
        if page.self_and_siblings.include?(@page) || page.children.include?(@page) || page.ancestors.include?(@page) || @page.child_of?(page)
          @pages = page.self_and_siblings
          break
        else
          @pages = []
        end
      end
    end
    render :layout => false
  end

  # handles AJAX requests sortable tree
  def order
    logger.debug "Saving page #{params[:id]} with position #{params[:position]} and parent #{params[:parent_id]}"
    if params[:page]
      params[:page].each {|key, value|
        info = value.split("|")
        logger.debug "Saving page #{key} with position #{info[0]} and parent #{info[1]}"
        p = Page.find(key)
        p.parent_id = info[1]
        p.position = info[0]
        p.save
      }
    end
    Notice.create(:user_id => current_user.id, :website_id => current_website.id, :message => 'reordered pages')
    render :status => 200, :nothing => true
  end

  private

  def page_params
    params.require(:page).permit %i(
      address
      description
      direct_link
      language
      login_required
      page_template_id
      parent_id
      password
      seo_title
      show_in_menu
      title
    )
  end
end
