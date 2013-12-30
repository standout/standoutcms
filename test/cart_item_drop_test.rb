require 'test_helper'

class CartItemDropTest < ActiveSupport::TestCase

  test 'cart item drop should be connected to product variant if variant was specified' do
    cart = Cart.create
    product = products(:product_with_variants)
    cart.add(product, 1, product.product_variants.first)
    drop = CartItemDrop.new(cart.reload.cart_items.first)
    assert_equal drop.product.id, product.id
    assert_equal drop.variant.id, product.product_variants.first.id
  end

  test 'cart item drop should not be connected to product variant if no variant was specified' do
    cart = Cart.create
    product = products(:testproduct)
    cart.add(product, 1)
    drop = CartItemDrop.new(cart.reload.cart_items.first)
    assert_equal drop.product.id, product.id
    assert_equal drop.variant, nil
  end

  test 'cart item drop should have notes' do
    cartitem = CartItem.create do |c|
      c.notes = 'test'
      c.product_id = products(:testproduct).id
    end
    drop = CartItemDrop.new(cartitem)
    assert_equal 'test', drop.notes
  end

end