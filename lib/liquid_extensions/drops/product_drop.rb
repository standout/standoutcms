class ProductDrop < Liquid::Drop

  require 'query_parser'
  include QueryParser

  def initialize(product)
    @product = product
  end

  def id
    @product.id
  end

  def title
    @product.title
  end

  def description
    @product.description
  end

  def price
    @product.price
  end

  def price_including_tax
    @product.price_including_tax
  end

  def tax
    @product.tax
  end

  def categories
    @product.product_categories.collect{ |c| ProductCategoryDrop.new(c) }
  end

  def related_products
    @product.related_products.collect{ |p| ProductDrop.new(p)}
  end

  def images
    @product.product_images
  end

  def images_count
    @product.product_images.size
  end

  def url
    @product.complete_url
  end

  def variants
    @product.product_variants.collect{ |v| ProductVariantDrop.new(@product, v) }
  end

  def vendor
    @product.vendor ? VendorDrop.new(@product.vendor) : {}
  end

  def updated_at
    @product.updated_at.to_s
  end

  # Returns the dynamic attributes of this product as a hash.
  # The wierd injection syntax is used to convert symbol based hash
  # to string based hash, accepted by liquid.
  def dynamic_attributes
    @da ||= @product.dynamic_attributes.inject({}){|da,(key,value)| da[key.to_s] = value.to_s; da}
  end

  private

  def search(h)
    # Do any custom filtering and stuff here ...
    Product.search_and_filter(h) if Product.respond_to? :search_and_filter
  end

end
