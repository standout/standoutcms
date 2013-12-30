require 'test_helper'

class DynamicAttributesTest < ActiveSupport::TestCase
  def setup
    @product = products(:one)
  end

  test 'it can create or update attributes from a hash' do
    attrs = {isbn: '12345', pages: 150}
    @product.update_dynamic_attributes(attrs)
    assert_equal @product.dynamic_attributes, attrs
  end

  test 'it ignores keys which are not set' do
    @product.update_dynamic_attributes(isbn: '12345', pages: 150)
    @product.update_dynamic_attributes(pages: 250)
    assert_equal @product.dynamic_attributes[:isbn], '12345'
  end

  test 'it implements getter methods' do
    @product.update_dynamic_attributes(pages: 200)
    assert_equal @product.pages, 200
  end

  test 'it implements setter methods' do
    @product.pages = 300
    assert_equal @product.pages, 300
  end

  test 'it handles strings' do
    @product.update_dynamic_attributes(isbn: '12345')
    assert_equal @product.dynamic_attributes[:isbn].class, String
  end

  test 'it handles integers' do
    @product.update_dynamic_attributes(pages: 500)
    assert_equal @product.dynamic_attributes[:pages].class, Integer
  end
end
