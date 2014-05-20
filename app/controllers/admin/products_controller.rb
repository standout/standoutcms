class Admin::ProductsController < ApplicationController

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

  def duplicate
    @product = @website.products.find(params[:id])
    new_product = @product.dup
    new_product.url = nil
    new_product.title = new_product.title.to_s + " copy"
    new_product.save

    # copy the images
    @product.product_images.each do |i|
      n = ProductImage.new(:product_id => new_product.id, :image => i.image)
      n.save
    end

    redirect_to [:edit, :admin, Product.find(new_product.id)], :notice => t('duplicated_product')
  end

  # GET /products
  # GET /products.json
  def index
    @products = @website.products.paginate(page: params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = unscoped_product

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new
    @product.website = @website

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = unscoped_product
  end

  # POST /products
  # POST /products.json
  def create
    params[:product][:product_category_ids] ||= []
    @product = Product.new(product_params)
    @product.website_id = @website.id

    respond_to do |format|
      if @product.save and @product.setup_property_values(params[:product_property_values])
        format.html { redirect_to [:admin, :products], notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    params[:product][:product_category_ids] ||= []
    @product = Product.unscoped.find(params[:id])
    @product.website_id = @website.id

    respond_to do |format|
      if @product.update(product_params) and @product.setup_property_values(params[:product_property_values])
        format.html { redirect_to [:admin, :products], notice: 'Product was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = unscoped_product
    @product.destroy

    respond_to do |format|
      format.html { redirect_to [:admin, :products] }
      format.json { head :ok }
    end
  end

  def unscoped_product
    product =
      Product.unscoped.where(id: params[:id], website_id: @website.id).first
    raise ActiveRecord::RecordNotFound unless product
    product
  end

  private

  def product_params
    params.require(:product).permit %i(
      title
      url
      description
      price
      vat_percentage
      url
      vendor_id
    )
  end
end
