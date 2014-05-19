class Admin::ProductCategoriesController < ApplicationController
  
  layout 'webshop'
  before_filter :check_login
  before_filter :load_website
  
  def load_website
    if current_user.admin?
      @website = current_website
    else
      @website = current_user.websites.find(current_website.id)
    end
  end
    
  # GET /product_categories
  # GET /product_categories.json
  def index
    @product_categories = @website.product_categories.roots

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @product_categories }
    end
  end

  # GET /product_categories/1
  # GET /product_categories/1.json
  def show
    @product_category = @website.product_categories.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product_category }
    end
  end

  # GET /product_categories/new
  # GET /product_categories/new.json
  def new
    @product_category = ProductCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product_category }
    end
  end

  # GET /product_categories/1/edit
  def edit
    @product_category = @website.product_categories.find(params[:id])
  end

  # POST /product_categories
  # POST /product_categories.json
  def create
    @product_category = ProductCategory.new(product_category_params)
    @product_category.website_id = @website.id

    respond_to do |format|
      if @product_category.save
        format.html { redirect_to [:admin, :product_categories], notice: 'Product category was successfully created.' }
        format.json { render json: @product_category, status: :created, location: @product_category }
      else
        format.html { render action: "new" }
        format.json { render json: @product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_categories/1
  # PUT /product_categories/1.json
  def update
    @product_category = @website.product_categories.find(params[:id])
    if params[:clean_products]
      @product_category.products.collect(&:destroy)
    end

    respond_to do |format|
      if @product_category.update(product_category_params)
        format.html { redirect_to [:admin, :product_categories], notice: 'Product category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_categories/1
  # DELETE /product_categories/1.json
  def destroy
    @product_category = @website.product_categories.find(params[:id])
    @product_category.destroy

    respond_to do |format|
      format.html { redirect_to [:admin, :product_categories] }
      format.json { head :ok }
    end
  end

  private

  def product_category_params
    params.require(:product_category).permit %i(
      website_id
      title
      description
      slug
      parent_id
    )
  end
end
