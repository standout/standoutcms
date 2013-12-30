class WebsiteDrop < Liquid::Drop

  def initialize(website)
    @website = website
  end

  def pages
    @website.root_pages.collect{ |p| PageDrop.new(p, @website.default_language)}
  end

  def posts
    @website.posts
  end

  def categories
    @website.categories
  end

  def lists
    stuff = {} 
    @website.custom_data_lists.each do |custom_data|
      stuff["#{custom_data.liquid_name}"] = CustomDataDrop.new(custom_data)
    end
    stuff
  end

  def products
    @website_products ||= @website.products.collect{ |p| ProductDrop.new(p) }
  end

  def product_categories
    @website.product_categories.roots.collect{ |c| ProductCategoryDrop.new(c) }
  end

  def latest_products
    @website.products.order("created_at desc").limit(30).collect{ |p| ProductDrop.new(p) }
  end

  def latest_product
    ProductDrop.new(@website.products.order("created_at desc").limit(1).first)
  end

  def last_updated_product
    ProductDrop.new(@website.products.order("updated_at desc").limit(1).first)
  end

  def latest_category
    ProductCategoryDrop.new(@website.product_categories.order("created_at desc").limit(1).first)
  end

  def vendors
    @website.vendors.map{ |v| VendorDrop.new(v) }
  end

  def title
    @website.title
  end

  def money_format
    @website.money_format
  end

  def currency_unit
    @website.currency_unit
  end

  def money_separator
    @website.money_separator
  end

end

class CustomDataDrop < Liquid::Drop

  def initialize(custom_data_list)
    @custom_data_list = custom_data_list
  end

  def id
    @custom_data_list.id
  end

  def items
    @custom_data_list.sorted_data_rows.collect{ |row| CustomDataRowDrop.new(row) }
  end

  def fields
    @custom_data_list.custom_data_fields
  end

end
