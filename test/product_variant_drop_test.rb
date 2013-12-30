require 'test_helper'

class ProductVariantDropTest < ActiveSupport::TestCase
  
  def setup
    @product = products(:product_with_variants)
    @variant = product_variants(:one)
    @variantdrop = ProductVariantDrop.new(@product, @variant)
  end
  
  test 'variant description should include color, size and material' do
    setup
    assert @variantdrop.description.match("#{@variant.color}")
    assert @variantdrop.description.match("#{@variant.size}")
    assert @variantdrop.description.match("#{@variant.material}")
    assert_equal @variantdrop.color, @variant.color
    assert_equal @variantdrop.size, @variant.size
    assert_equal @variantdrop.material, @variant.material
  end

  test 'variant description should only include things that are set' do
    @variant.size = ''
    @variant.material = ''
    @variant.color = 'red'
    pvd = ProductVariantDrop.new(@product, @variant)
    assert_equal pvd.description.scan(/\,/).size, 0
    @variant.size = 'large'
    pvd = ProductVariantDrop.new(@product, @variant)
    assert_equal pvd.description.scan(/\,/).size, 1
    @variant.material = 'wool'
    pvd = ProductVariantDrop.new(@product, @variant)
    assert_equal pvd.description.scan(/\,/).size, 2
  end
  
  test 'variant tax should be based on product tax' do
    setup
    @variant.price = 100.0
    @variant.save
    assert_equal(@variantdrop.tax, 25.0)
    @variant.price = 200.0
    @variant.save
    assert_equal(@variantdrop.tax, 50.0)
  end
  
  test 'price including tax should be price + tax' do
    setup
    @product.vat_percentage = 25.0
    @variant.price = 1000.0
    variantdrop = ProductVariantDrop.new(@product, @variant)
    assert_equal variantdrop.price_including_tax, 1250.0
    @variant.price = 40.0
    variantdrop = ProductVariantDrop.new(@product, @variant)
    assert_equal variantdrop.price_including_tax, 50.0
  end
  
  test 'variantdrop id should be the same as variant id' do
    assert_equal(@variant.id, @variantdrop.id)
  end
    
end