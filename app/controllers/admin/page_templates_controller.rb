class Admin::PageTemplatesController < ApplicationController
  
  before_filter :check_login
  before_filter :load_website_and_look
  layout 'admin/looks'
  
  def load_website_and_look
    @website = current_website
    @look = @website.looks.find(params[:look_id])
  end
  
  def index
    @page_templates = @look.page_templates
  end

  def show
    @page_template = PageTemplate.find(params[:id])
  end

  def new
    @page_template = PageTemplate.new
  end

  def create
    @page_template = PageTemplate.new(page_template_params)
    @page_template.look_id = @look.id
    @page_template.updated_by = current_user
    if @page_template.save
      Notice.create(:message => I18n.t('notices.page_template.created_by_user', :title => @page_template.name), :website_id => current_website.id, :user_id => current_user.id)
      flash[:notice] = "Successfully created page template."
      redirect_to [:edit, :admin, @look, @page_template]
    else
      render :action => 'new'
    end
  end

  def edit
    @page_template = @look.page_templates.find(params[:id])
    @page_template.revert_to(params[:version].to_i) if params[:version]
  end

  def update
    @page_template = @look.page_templates.find(params[:id])
    @page_template.updated_by = current_user
    if @page_template.update(page_template_params)
      Notice.create(:message => I18n.t('notices.page_template.updated_by_user', :title => @page_template.name), :website_id => current_website.id, :user_id => current_user.id)
      flash[:notice] = "Successfully updated page template."
      redirect_to [:edit, :admin, @look, @page_template]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @page_template = @look.page_templates.find(params[:id])
    @page_template.destroy
    Notice.create(:message => I18n.t('notices.page_template.deleted_by_user', :title => @page_template.name), :website_id => current_website.id, :user_id => current_user.id)
    flash[:notice] = "Successfully destroyed page template."
    redirect_to [:admin, @look]
  end

  private

  def page_template_params
    params.require(:page_template).permit %i(
      look_id
      slug
      name
      default_template
      partial
      html
    )
  end
end
