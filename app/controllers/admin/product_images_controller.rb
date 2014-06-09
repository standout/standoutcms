class Admin::ProductImagesController < ApplicationController

  before_filter :check_login
  before_filter :load_website_and_parent

  def load_website_and_parent
    if current_user.admin?
      @website = current_website
    else
      @website = current_user.websites.find(current_website.id)
    end

    @parent =
      params[:product_id] ?
      @website.products.find(params[:product_id]) :
      @website.product_categories.find(params[:product_category_id])
  end


  def create
    @product_image = @parent.product_images.new(product_image_params)
    @product_image.save!
    redirect_to [:edit, :admin, @parent]
  end

  def order
    @parent.product_images.each do |image|
      image.position = params['product_image'].index(image.id.to_s) + 1
      image.save
    end
    render :text => "order: #{params.inspect}"
  end

  def edit
    @product_image = @parent.product_images.find(params[:id])
  end

  def update
    @product_image = @parent.product_images.find(params[:id])
    @product_image.update(product_image_params)
    redirect_to :back
  end

  def destroy
    @product_image = @parent.product_images.find(params[:id])
    @product_image.destroy
    redirect_to :back
  end

  private

  def product_image_params
    params.require(:product_image).permit %i(
      image
      crop_x
      crop_y
      crop_w
      crop_h
    )
  end

end
