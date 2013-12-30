class ProductCategory < ActiveRecord::Base

  include ModelSearch
  include Tokenizer

  attr_accessible :website_id, :title, :description, :slug, :parent_id
  acts_as_tree :scope => 'website_id'

  has_and_belongs_to_many :products
  has_many :product_images, -> { order 'position desc' }, :dependent => :destroy
  has_many :attachment_files, :dependent => :destroy
  belongs_to :website
  before_save :check_url
  has_many :url_pointers, :dependent => :destroy
  after_save :create_url_pointer

  validates :slug, :uniqueness => { :scope => :website_id }

  # We don't want empty URL fields
  def check_url
    self.slug = "#{self.id}-#{self.title.to_s}".parameterize if self.slug.to_s == ""
  end

  # The URL needs to be reserved in the global namespace.
  # TODO: ability to change /products/ to something user defined.
  def create_url_pointer
    if self.slug && self.slug_changed?
      UrlPointer.create(:product_category_id => self.id, :website_id => self.website_id, :path => "/categories/" + self.slug, :language => self.website.default_language)
    end
  end

  def as_json(opts = {})
    attributes
      .merge(product_images: product_images.map(&:url))
      .merge(attachment_files: attachment_files.map(&:url))
  end

  def to_liquid
    {
      "title" => self.title,
      "url" => self.complete_url,
      "description" => self.description,
      "products" => ProductCategoryDrop.new(self),
      "subcategories" => self.children,
      "products_count" => self.products.size
    }
  end

  def complete_path
    "/categories/#{self.slug}"
  end

  def complete_url
    "http://#{self.website.main_domain}/categories/#{self.slug}"
  end

  def complete_html(language = 'sv')

    if self.page_template.nil?
      return "You need a page templated called 'product_category' to render this page."
    end

    stuff = {
			'product_category'	=> ProductCategoryDrop.new(self),
			'page_template_id'  => self.page_template.id,
      'language'					=> self.website.default_language,
      'posts' 						=> self.website.posts,
      'categories'				=> self.website.blog_categories,
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
      menu_item = Menu.find_or_create_by_page_template_id_and_for_html_id(self.page_template.id, menu.attributes['id'])
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
    t = self.website.page_templates.where(:slug => 'product_category').first
  end

  def search_class
    Product
  end

  def search_free_text_columns
    ["title","description"]
  end

end

