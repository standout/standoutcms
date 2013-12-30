class ProductCategoryDrop < Liquid::Drop

  require 'query_parser'
  include QueryParser

  def initialize(category)
    @category = category
    super(@category)
  end

  def description
    @category.description
  end

  def id
    @category.id.to_s
  end

  def products
    @category.products.collect{ |p| ProductDrop.new(p) }
  end

  def products_count
    @category.products.size
  end

  def subcategories
    @category.children.collect{ |c| ProductCategoryDrop.new(c) }
  end

  def parent
    @category.parent ? ProductCategoryDrop.new(@category.parent) : {}
  end

  def root?
    self.root?
  end

  def title
    @category.title
  end

  def url
    @category.complete_url
  end

  # Returns { :small, :medium, :large }
  def image
    @category.product_images.first.to_liquid if @category.product_images
  end

  def images
    @category.product_images
  end

end
