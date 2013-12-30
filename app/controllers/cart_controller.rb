class CartController < ApplicationController

  before_filter :load_cart
  skip_before_filter :verify_authenticity_token

  # Add an item to the shopping cart
  def add
    product = current_website.products.find(params[:product_id])
    variant = product.product_variants.find(params[:variant_id]) if params[:variant_id]
    quantity = params[:quantity].to_i
    if @cart.add(product, quantity, variant, params[:notes])
      respond_to do |format|
        format.html { redirect_to product.complete_url }
        format.json { render :json => @cart.to_json }
      end
    end
  end

  # Display the contents of the shopping cart
  def show
    page_template = current_website.page_templates.where(:slug => 'cart').first
    if page_template.blank?
      render :text => 'You need a page templated called "cart" to render the cart.'
    else
      render :text => render_the_template(current_website, page_template, @cart, {})
    end
  end

  def update
    product = current_website.products.find(params[:product_id])
    variant = product.product_variants.find(params[:variant_id]) if params[:variant_id]
    quantity = params[:quantity].to_i
    if @cart.update_cart(product, quantity, variant, params[:notes])
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { render :json => @cart.to_json }
      end
    end
  end

  def index
    show
  end

  # Remove the entire contents of the cart
  def destroy
    @cart.destroy
    redirect_to "/"
  end

  protected

  def load_cart
    @cart = current_cart
  end

end
