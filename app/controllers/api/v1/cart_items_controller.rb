class Api::V1::CartItemsController < Api::V1::BaseController
  before_filter :find_cart_item, only: [:update, :destroy]

  def index
    @cart = Cart.find_by_api_key(params[:cart_id])
    render json: @cart.cart_items.to_json
  end

  def create
    @cart = Cart.find_by_api_key(params[:cart_id])
    @cart_item = CartItem.create({cart_id: @cart.id}.merge(cart_item_params))
    render json: @cart_item
  end

  def update
    if @cart_item.update(cart_item_params)
      render json: @cart_item
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render nothing: true, status: (@cart_item.destroy ? 200 : 400)
  end

  def find_cart_item
    @cart_item = CartItem.find_by_api_key(params[:id])
  end

  def cart_item_params
    accessible = [:product_id, :quantity, :notes]
    params.select{ |key, value| accessible.include?(key.to_sym) }
  end

  private

  def cart_item_params
    params.permit %i(
      title
      product_id
      quantity
      price_per_item
      vat_percentage
      product_variant_id
      notes
      api_key
    )
  end
end
