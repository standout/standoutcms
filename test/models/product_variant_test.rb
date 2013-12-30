require 'test_helper'

class ProductVarianttest < ActiveSupport::TestCase
  test 'inventory should decrease to the given value' do
    product_variant = product_variants(:one)
    assert_equal product_variant.inventory, 10
    product_variant.countdown_inventory(5)
    assert_equal product_variant.inventory, 5
  end

  test 'product variant should have a description' do
    variant = product_variants(:one)
    assert_equal "black large latex", variant.description
  end
end
