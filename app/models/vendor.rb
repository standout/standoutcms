class Vendor < ActiveRecord::Base
  validates :slug, uniqueness: true

  # attr_accessor :logo_file_name, :logo_content_type, :logo_file_size, :logo_updated_at
  has_attached_file :logo,
    styles: { :small => "120x120" },
    default_url: "/images/missing.png",
    path: ":rails_root/public/system/logos/:id/:style/:filename",
    url: "/system/logos/:id/:style/:filename"

  validates_attachment_content_type :logo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  has_many      :products
  has_many      :url_pointers, -> { order('created_at asc') }, dependent: :destroy
  belongs_to    :website

  before_save   :check_url
  after_save    :create_url_pointer
  after_destroy :remove_connections

  def remove_connections
    self.products.each do |p|
      p.update_attribute :vendor_id, nil
    end
  end

  def complete_path
    "/vendors/#{self.slug}"
  end

  def complete_url
    "http://#{self.website.main_domain}/vendors/#{self.slug}"
  end

  # We don't want empty URL fields
  def check_url
    self.slug = "#{self.id}-#{self.name.to_s}".parameterize if self.slug.to_s == ""
  end

  # Do a lookup for page templates for this product
  def page_template
    website.page_templates.where(slug: 'vendor').first
  end

  # This creates a URL to the vendor, and it also removes previous
  # URL:s if needed.
  def create_url_pointer
    if (self.slug && self.slug_changed?) || self.url_pointers.empty?
      UrlPointer.create do |up|
        up.vendor_id = self.id
        up.website_id = self.website_id
        up.path = "/vendors/" + self.slug
        up.language = self.website.default_language
      end
    end

    if url_pointers.count > 1
      url_pointers.first.destroy
    end
  end

end
