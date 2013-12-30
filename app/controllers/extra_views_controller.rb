# encoding: utf-8
class ExtraViewsController < ApplicationController
  # GET /extra_views
  # GET /extra_views.xml
  def index
    @extra_views = ExtraView.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @extra_views }
    end
  end

  def choose
    @extra_view = ExtraView.find(params[:id])
    @content_item = ContentItem.find(params[:content_item_id])
    @content_item.update_attribute :extra_view_id, @extra_view.id
    @content_item.check_for_stickies
    render :text => "Done"
  end

  # GET /extra_views/1
  # GET /extra_views/1.xml
  def show
    @extra_view = ExtraView.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @extra_view }
    end
  end

  # GET /extra_views/new
  # GET /extra_views/new.xml
  def new
    @extra_view = ExtraView.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @extra_view }
    end
  end

  # GET /extra_views/1/edit
  def edit
    @extra_view = ExtraView.find(params[:id])
  end

  # POST /extra_views
  # POST /extra_views.xml
  def create
    @extra_view = ExtraView.new(params[:extra_view])
    @content_item = ContentItem.find(params[:content_item])
      if @extra_view.save
        render :update do |page|
          page.replace_html "plugin_views", :partial => "extras/extraview", :collection => ExtraView.find(:all, :conditions => ["extra_id = ?", @extra_view.extra_id])
        end
      else
        render :update do |page|
          page.alert "Kunde inte skapa visningsalternativet."
        end
      end
  end

  # PUT /extra_views/1
  # PUT /extra_views/1.xml
  def update
    @extra_view = ExtraView.find(params[:id])

    respond_to do |format|
      if @extra_view.update_attributes(params[:extra_view])
        flash[:notice] = 'ExtraView was successfully updated.'
        format.html { redirect_to(@extra_view) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @extra_view.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /extra_views/1
  # DELETE /extra_views/1.xml
  def destroy
    @extra_view = ExtraView.find(params[:id])
    @extra_view.destroy

    respond_to do |format|
      format.html { redirect_to(extra_views_url) }
      format.xml  { head :ok }
    end
  end
end
