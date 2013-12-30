require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  test 'Product should not save without attributes' do
    product = Product.new()
    assert !product.save
  end

  test 'Product should not save without title' do
    product = Product.new()
    product.website_id = websites(:standout).id
    assert !product.save
  end

  test 'Product should not save without website' do
    product = Product.new()
    product.title = "Test (Product should not save without website)"
    assert !product.save
  end

  test 'Product should save with only required attributes' do
    product = Product.new()
    product.title = "Test (Product should save with only required attributes)"
    product.website_id = websites(:standout).id
    assert product.save!
  end

  test 'it deletes itself softly' do
    product = Product.create! do |p|
      p.title = 'Test'
      p.website_id = websites(:standout).id
      p.url = 'testitdeletesitselfsoftly'
    end
    count = Product.count
    product.destroy
    assert_equal Product.count, count - 1
    assert_equal Product.unscoped.count, count
  end

  test 'product url pointers are removed after destruction' do
    assert_difference 'UrlPointer.count' do
      @product = Product.create! do |p|
        p.title = 'ABC'
        p.website_id = websites(:standout).id
        p.url = 'somethingunique1234'
      end
    end

    assert_difference('UrlPointer.count', -1) do
      @product.destroy
    end

  end

end
