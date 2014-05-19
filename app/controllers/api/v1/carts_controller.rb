class Api::V1::CartsController < Api::V1::BaseController
  before_filter :find_cart, except: :create

  def create
    @website = Website.find(params[:website_id])
    @cart = Cart.create(website_id: @website.id)
    render json: @cart
  end

  def show
    render json: @cart
  end

  def update
    if @cart.update(cart_params)
      render json: @cart
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  def empty
    @cart.empty
    render nothing: true
  end

  def find_cart
    @cart = Cart.find_by_api_key(params[:id])
  end

  def cart_params
    params.permit(:notes)
  end
end
