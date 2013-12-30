require 'test_helper'
class ProductCategoryDropTest < ActiveSupport::TestCase

  test 'product category should have children' do

    # Create a page category with children
    @category = ProductCategory.create do |c|
      c.website_id = websites(:standout).id
      c.title = 'Main category'
    end

    ProductCategory.create do |c|
      c.website_id = websites(:standout).id
      c.title = 'Subcategory'
      c.parent_id = @category.id
    end

    drop = ProductCategoryDrop.new(@category)
    assert_equal 'Subcategory', drop.subcategories.first.title
  end

end