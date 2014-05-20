class Admin::BlogCategoriesController < ApplicationController

  before_filter :check_login  
  before_filter :load_website
  
  def load_website
    if current_user.admin?
      @website = current_website
    else
      @website = current_user.websites.find(current_website.id)
    end
  end
  
  def index
    @blog_categories = @website.blog_categories
    respond_to do |format|
      format.html { render :layout => request.xhr? ? false : 'application' } 
    end
  end

  def show
    @blog_category = @website.blog_categories.find(params[:id])
  end

  def new
    @blog_category = BlogCategory.new
  end

  def create
    @blog_category = BlogCategory.new(blog_category_params)
    @blog_category.website_id = @website.id
    if @blog_category.save
      respond_to do |format|
        format.html { redirect_to [:admin, :blog_categories] }
        format.js { render :text => "Category created." }
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @blog_category = @website.blog_categories.find(params[:id])
    respond_to do |format|
      format.html { render :layout => request.xhr? ? false : 'application' } 
    end
  end

  def update
    @blog_category = @website.blog_categories.find(params[:id])
    if @blog_category.update(blog_category_params)
      flash[:notice] = "Successfully updated blog category."
      redirect_to [:admin, :blog_categories]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @blog_category = @website.blog_categories.find(params[:id])
    @blog_category.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, :blog_categories] }
      format.js { render :text => 'Category removed.' }
    end
  end

  private

  def blog_category_params
    params.require(:blog_category).permit %i(
      website_id
      name
    )
  end
end
