require 'test_helper'

class CartControllerTest < ActionController::TestCase

  def setup
    @controller = CartController.new
    request.host = "standout.standoutcms.dev"
  end

  test 'should be able to add a product variant to the cart' do
    product = products(:product_with_variants)
    post :add, { :product_id => product.id, :quantity => 1, :variant_id => product.product_variants.first.id }
    assert_response :redirect
    cart = Cart.find(assigns(:cart).id)
    assert_equal cart.cart_items.last.product_variant_id, product.product_variants.first.id
  end

  test 'should be able to add a product without variant to the cart' do
    product = products(:testproduct)
    post :add, { :product_id => product.id, :quantity => 1 }
    assert_response :redirect
    cart = Cart.find(assigns(:cart).id)
    assert_equal cart.cart_items.last.product_id, product.id
  end

  test 'should be able to update at product with variant to the cart' do
    product = products(:product_with_variants)

    # First, add a product variant to the cart
    post :add, { :product_id => product.id, :quantity => 1, :variant_id => product.product_variants.first.id }
    cart = Cart.find(assigns(:cart).id)
    assert cart.cart_items.last.quantity == 1 && cart.cart_items.last.product_id == product.id

    # Now, try to update the quantity
    request.env["HTTP_REFERER"] = "http://standout.standoutcms.dev/cart"
    post :update, { :product_id => product.id, :quantity => 5, :variant_id => product.product_variants.first.id }
    assert_response :redirect
    assert_equal cart.cart_items.last.quantity, 5
    assert_equal cart.cart_items.last.product_id, product.id
    assert_equal cart.cart_items.last.product_variant_id, product.product_variants.first.id
  end

  test 'should be able to add notes with a cart item' do
    product = products(:testproduct)
    post :add, { product_id: product.id, quantity: 1, notes: "test" }
    cart = Cart.find(assigns(:cart).id)
    assert_equal "test", cart.cart_items.last.notes

    request.env["HTTP_REFERER"] = "http://standout.standoutcms.dev/cart"
    post :update, { product_id: product.id, quantity: 2, notes: "test2" }
    assert_equal "test2", cart.reload.cart_items.last.notes
  end

end