require 'test_helper'

class CartTest < ActiveSupport::TestCase

  test 'adding a product should increase quantity' do
    cart = Cart.create
    assert_equal cart.total_items_count, 0
    cart.add(products(:testproduct))
    assert_equal cart.total_items_count, 1
  end

  test 'adding the same product twice should not add another cart item' do
    cart = Cart.create
    cart.add(products(:testproduct))
    cart.add(products(:testproduct))
    assert_equal 2, cart.total_items_count
    assert_equal 1, cart.cart_items.size
  end

  test 'setting quantity to 0 should remove item from cart' do
    cart = Cart.create
    cart.add(products(:testproduct))
    assert_equal 1, cart.cart_items.size
    cart.update_cart(products(:testproduct), 0)
    assert_equal 0, cart.cart_items.size
  end

  test 'adding a variant should work' do
    cart = Cart.create
    product = products(:product_with_variants)
    cart.add(product, 1, product.product_variants.first)
    assert_equal 1, cart.total_items_count
    assert_equal cart.cart_items.first.product_variant_id, product.product_variants.first.id
  end

  test 'should not charge for shipping when empty' do
    cart = Cart.create
    assert_equal cart.shipping_cost, 0
  end

  test 'cart can have a reseller' do
    cart = Cart.create
    cart.reseller = 'abc'
    cart.save!
    assert_equal 'abc', cart.reload.reseller
  end

end
