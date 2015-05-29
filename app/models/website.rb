class Website < ActiveRecord::Base

  include ModelSearch
  include Tokenizer

  store :settings, accessors: [
    :webshop_currency,
    :paypal_business_email,
    :dibs_merchant_id,
    :dibs_hmac_key,
    :webshop_live,
    :order_confirmation_title,
    :order_confirmation_header,
    :order_confirmation_footer,
    :payment_confirmation_title,
    :payment_confirmation_header,
    :payment_confirmation_footer,
    :money_format,
    :money_separator,
    :member_signup_enabled,
    :filtered_attributes
  ]

  # Available currencies
  CURRENCIES = { 'SEK' => 'kr', 'USD' => '$' }

  has_many :pages
  has_many :assets
  has_many :attachment_files
  has_many :looks, :dependent => :destroy
  has_many :members
  has_many :users, :through => :website_memberships
  has_and_belongs_to_many :extras, -> { uniq true }
  has_many :servers
  has_many :galleries
  has_many :website_memberships
  has_many :posts, -> { order 'created_at desc' }
  has_many :blog_categories, -> { order 'name desc' }
  has_many :custom_data_lists
  has_many :notices, -> { order 'created_at desc' }
  has_many :orders, -> { order 'created_at desc' }, dependent: :destroy
  has_many :carts, :dependent => :destroy
  has_many :customers, -> { order 'created_at desc' }, dependent: :destroy
  has_many :page_templates, :through => :looks
  has_many :product_categories, -> { order 'title asc' }, dependent: :destroy
  has_many :products, :dependent => :destroy
  has_many :url_pointers, -> { order 'created_at desc' }, dependent: :destroy
  has_many :vendors, -> { order 'name asc' }, dependent: :destroy
  has_many :releases, -> { order 'created_at desc' }, dependent: :destroy
  has_many :shipping_costs, :dependent => :destroy
  has_many :product_property_keys, :dependent => :destroy

  before_create :generate_api_key
  after_initialize :create_default_settings
  belongs_to :blog_page, :class_name => 'Page'

  validates_uniqueness_of :subdomain
  validates_presence_of :subdomain

  # Could be either subdomain or main domain.
  def main_domain
    if self.domain.to_s == ""
      "#{self.subdomain}.standoutcms.#{self.tld}"
    else
      "#{self.domain}"
    end
  end

  def url
    "http://#{domain}"
  end

  def tld
    Rails.env.development? ? "dev" : "se"
  end

  def generate_liquid(language = nil)
    language ||= self.default_language
    lists = {}
    self.custom_data_lists.each do |cd|
      lists["#{cd.liquid_name}"] = cd.sorted_data_rows.collect{ |c| CustomDataRowDrop.new(c) }
    end

    l = {
      "settings" => { "title" => self.title, "domain" => self.domain, "default_language" => self.default_language },
      "posts" => self.posts.collect(&:to_liquid),
      "categories" => self.blog_categories.collect(&:to_liquid),
      "lists" => lists,
      "pages" => self.root_pages.collect{ |p| PageDrop.new(p, language) },
      "product_categories" => self.product_categories.roots.collect{ |c| ProductCategoryDrop.new(c) },
      "vendors" => VendorsDrop.new(self)
    }
  end

  def languages
    Language.all(:order => 'name')
  end

  def self.find_by_domainaliases(aliases)
    Website.where("domainaliases LIKE ?", "%" + aliases.to_s + "%").first
  end

  # Returns all matching shipping costs, uniquely.
  def get_matching_shipping_costs(value)
    shipping_costs.map{ |s| s.calculate_cost(value) }.reject(&:!).uniq
  end

  def root_pages
    @root_pages ||= pages.where(parent_id: 0).order('position asc')
  end

  def default_language
    self[:default_language].nil? ? 'sv' : self[:default_language]
  end

  def root_url
    self.servers.first.root_url rescue ''
  end

  def domains
    [self.domain]
  end

  def updated_pages_since(datetime)
    return [] if datetime.nil?
    self.pages.all.where(["updated_at >= ?", datetime])
  end

  def admins
    self.website_memberships.collect{ |wm| wm.user unless wm.restricted_user? }.compact
  end

  def currency_unit
    CURRENCIES[self.webshop_currency].to_s
  end

  def update_filtered_attributes(template = {})
    a = (Product.column_names + ProductPropertyKey.where(website_id: self.id).map(&:slug)).flatten
    a -= ["id", "website_id", "vat_percentage", "created_at", "updated_at", "deleted_at", "url", "vendor_id"]
    self.filtered_attributes = Hash[*a.collect {|a| [a, template[a] == true]}.flatten]
  end

  def webshop_live?
    webshop_live == "1"
  end

  def member_signup_enabled?
    member_signup_enabled == "1"
  end

  private

  def generate_api_key
    self.api_key = rand(2**256).to_s(36)[0..15] if self.api_key.blank?
  end

  def create_default_settings
    self.webshop_currency ||= 'SEK'
    self.webshop_live     ||= '0'
    self.money_format     ||= '%n %u'
    self.money_separator  ||= ','
    self.member_signup_enabled ||= "0"
    update_filtered_attributes unless self.filtered_attributes
  end

  def search_class
    Product
  end

  def search_free_text_columns
    ["title","description"]
  end

end
