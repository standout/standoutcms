class Product < ActiveRecord::Base

  # TODO:Add sensible defaults to model. Right now price gets NIL of not set...
  #      0.00 would be a better default, don't you think?

  include DynamicAttributes
  include ModelSearch

  SEARCH_CLASS = ProductVariant

  default_scope { where "deleted_at IS NULL" }

  validates_presence_of :title, :website
  validates :url, uniqueness: { scope: :website_id }

  has_many :product_images, -> { order 'position' }, dependent: :destroy
  has_and_belongs_to_many :product_categories
  has_many :related_products, :through => :product_relations
  has_many :product_relations, :dependent => :destroy
  has_many :product_variants, :dependent => :destroy
  has_many :url_pointers, :dependent => :destroy
  has_many :product_property_values, :dependent => :destroy
  belongs_to :website
  belongs_to :vendor
  VAT_RATES = [25, 12, 6, 0]

  after_destroy :remove_all_product_relations, :remove_url_pointers
  before_validation :check_url
  before_save :check_vat_percentage
  after_save :create_url_pointer

  def self.importable_attributes
    ['title']
  end

  def destroy(soft = true)
    if soft
      self.update_attribute(:deleted_at, Time.now.utc)
      self.update_attribute(:url, url + "-#{Time.now.to_s}") # free url for other products to use
      remove_url_pointers
      remove_all_product_relations
    else
      super()
    end
  end

  def setup_property_values(property_values)
    return true unless property_values
    property_values.each do |property, value|
      send("#{property}=", value)
    end
  end

  # We don't want empty URL fields
  def check_url
    self.url = "#{self.id}-#{self.title.to_s}".parameterize if self.url.to_s == ""
  end

  def check_vat_percentage
    self.vat_percentage = 25 unless self.vat_percentage
  end

  # The URL needs to be reserved in the global namespace.
  # TODO: ability to change /products/ to something user defined.
  def create_url_pointer
    if self.url && self.url_changed?
      UrlPointer.create do |up|
        up.product_id = self.id
        up.website_id = self.website_id
        up.path = "/products/" + self.url
        up.language = self.website.default_language
      end
    end
  end

  def price_including_tax
    (self.price.to_f + self.tax.to_f).round(2)
  end

  def tax
    self.price.to_f * self.vat_percentage * 0.01
  end

  def as_json(opts = {})
    attributes.merge(dynamic_attributes).merge(
      product_category_ids: product_categories.map(&:id),
      thumbnail: product_images.any? ? product_images.first.image.url(:small) : ''
    )
  end

  def to_liquid
    ProductDrop.new(self)
  end

  def complete_path
    "/products/#{self.url}"
  end

  def complete_url
    "http://#{self.website.main_domain}/products/#{self.url}"
  end

  def complete_html(current_member, language = 'sv', cart_id = nil)

    if self.page_template.nil?
      return "You need a page templated called 'product' to render this page."
    end

    stuff = {
      'cart'              => CartDrop.new(cart_id),
      'product'           => ProductDrop.new(self),
      'page_template_id'  => self.page_template.id,
      'language'          => self.website.default_language,
      'posts'             => self.website.posts,
      'categories'        => self.website.blog_categories,
      'current_member' => current_member ? MemberDrop.new(current_member) : nil,
      'website'           => WebsiteDrop.new(self.website) }

    self.website.custom_data_lists.each do |custom_data|
      stuff["#{custom_data.liquid_name}"] = custom_data
    end

    doc = Hpricot(Liquid::Template.parse(self.page_template.html.to_s).render(stuff))

    # Our extra javascripts and CSS files
    begin
      doc.at("head").inner_html = "\n<meta name='description' content='#{self.description(language)}' />\n" << doc.at("head").inner_html
    rescue
      logger.info "Warning: could not find head/title-tag. Might be because of liquid inclusion though."
    end

    # Menu items
    doc.search(".menu").each do |menu|
      menu_item = Menu.find_or_create_by(page_template_id: self.page_template.id, for_html_id: menu.attributes['id'])
      menu_item.start_level = menu.attributes['data-startlevel'] if menu.attributes['data-startlevel'] != ""
      menu_item.levels = menu.attributes['data-sublevels'] if menu.attributes['data-sublevels'] != ""
      menu.inner_html = menu_item.html(website.root_pages.first, language)
    end

    doc.to_original_html
  rescue => e
     logger.info "#{e.inspect}"
     logger.info e.backtrace.join("\n")
    "<html><body><h2>Page Generation Error: #{e.message}</h2><p>#{e.backtrace.join("<br>")}</p></body></html>"
  end

  # Do a lookup for page templates for this product
  def page_template
    t = self.website.page_templates.where(:slug => 'product').first
  end

  def remove_all_product_relations
    ProductRelation.where(:related_product_id => self.id).collect(&:destroy)
  end

  def related_product_candidates
    self.website.products - self.related_products - [self]
  end

  private
  def remove_url_pointers
    self.url_pointers.collect(&:destroy)
  end

end
