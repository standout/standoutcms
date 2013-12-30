require 'test_helper'

class ProductCategoryTest < ActiveSupport::TestCase

  test 'slug should only be unique within website context' do
    product_category = ProductCategory.create(slug: 'test', website_id: websites(:standout).id)
    assert product_category.valid?
    product_category = ProductCategory.create(slug: 'test', website_id: websites(:lenhovda).id)
    assert product_category.valid?
 end

  test 'slug should be unique' do
    product_category = ProductCategory.create(slug: 'test', website_id: websites(:standout).id)
    assert product_category.valid?
    product_category = ProductCategory.create(slug: 'test', website_id: websites(:standout).id)
    assert !product_category.valid?
  end

  test 'filtering on attribute should return only relevant products' do
    price = 100.0 # Change here to change what price is used for the test...
  	filtered_products = ProductCategoryDrop.new(product_categories(:one)).invoke_drop("filter__price__above#{price.to_i}")
  	all_products = ProductCategoryDrop.new(product_categories(:one)).invoke_drop('products')
  	# Make sure we got vaild responses
  	assert !filtered_products.nil?
  	assert !all_products.nil?
  	# Make sure we got some results (adjust filter params or fixtures to ensure)
  	assert !filtered_products.empty?
  	assert !all_products.empty?
  	# Make sure we got only matching products
  	filtered_products.each do |p|
  		assert p.price > price
  	end
	end

  test 'filtering on attribute should return all relevant products' do
    price = 100.0 # Change here to change what price is used for the test...
    filtered_products = ProductCategoryDrop.new(product_categories(:one)).invoke_drop("filter__price__above#{price.to_i}")
    all_products = ProductCategoryDrop.new(product_categories(:one)).invoke_drop('products')
    # Make sure we got vaild responses
    assert !filtered_products.nil?
    assert !all_products.nil?
    # Make sure we got some results (adjust filter params or fixtures to ensure)
    assert !filtered_products.empty?
    assert !all_products.empty?
    # Make sure we got ALL matching products
    ids_array = filtered_products.map(&:id)
    inverse_products = ProductCategoryDrop.new(product_categories(:one)).invoke_drop('products').delete_if {|pd| ids_array.include? pd.id}

    inverse_products.each do |p|
      assert p.price <= price
    end
  end

	test 'filtering should return only products from the filtered category' do
		category = ProductCategory.find_by_slug('One')
		filtered_products = ProductCategoryDrop.new(category).invoke_drop("filter__price__above0")
  	# Make sure we got vaild responses
  	assert !filtered_products.nil?
  	# Make sure we got some results (adjust filter params or fixtures to ensure)
  	assert !filtered_products.empty?
  	# Make sure we got only products from the right category
  	filtered_products.each do |p|
  		assert p.categories.map(&:id).include? category.id.to_s
  	end
	end

	test 'filtering on dynamic attribute should work' do
		category = ProductCategory.find_by_slug('One')
    filtered_products = ProductCategoryDrop.new(category).invoke_drop("filter__pages__above200")
    assert !filtered_products.nil?
    assert !filtered_products.empty?
    assert_equal filtered_products.length, 1
	end

	test 'filtering on blocked product attribute should not work' do
		category = ProductCategory.find_by_slug('One')

    # Make sure we filter on something that has an effect
    filtered_products = ProductCategoryDrop.new(category).invoke_drop("filter__pages__above200")
    assert !filtered_products.nil?
    assert_not_equal filtered_products.length, ProductCategoryDrop.new(category).products.length

    # Block filtering on the pages dynamic attribute
    website = category.website
    website.filtered_attributes["pages"] = true
    assert website.save

    # And make sure we can't filter on that any more ...
    filtered_products = ProductCategoryDrop.new(category).invoke_drop("filter__pages__above200")
    assert !filtered_products.nil?
    assert_equal filtered_products.length, ProductCategoryDrop.new(category).products.length
	end

  test 'searching should work' do
    test_string = "Test" # Change what to search for here
    category = ProductCategory.where(slug: 'One').first
    assert !category.nil?
    filtered_products = ProductCategoryDrop.new(category).invoke_drop("search__query_string__#{test_string}")
    assert !filtered_products.nil?
    assert !filtered_products.empty?
    assert_equal filtered_products.length, 2
    filtered_products.each do |p|
      the_truth = false
      category.search_free_text_columns.each do |col|
        the_truth = (the_truth or p.send(col).include? test_string)
      end
      assert the_truth
    end
  end
end
