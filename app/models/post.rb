class Post < ActiveRecord::Base
  
  belongs_to :website
  belongs_to :blog_category, :foreign_key => 'blog_category_id'
  before_create :set_slug

  def to_liquid
    { "id" => self.id,
      "title"  => self.title,
      "content" => self.content, 
      "category" => (self.blog_category.nil? ? "" : self.blog_category.name), 
      "created_at" => self.created_at,
      "slug" => self.slug,
      "url" => self.url,
      "language" => self.language,
      "template" => self.page_template.slug }
  end
  
  def slug
    self[:slug].blank? ? self.set_slug : self[:slug]
  end
  
  def set_slug
    self.slug = self.to_slug
  end
  
  # Convert title David's Great Blog Post => davids_great_blog_post
  def to_slug
    ret = self.title.to_slug
  end
  
  # Make sure this item has an url registered
	def create_url_pointer
    UrlPointer.create(:website_id => self.website_id, :post_id => self.id, :path => self.slug, :language => self.language) if self.url_pointers.empty?
	end
  
  def url
    "http://#{self.website.domain}/#{self.slug}"
  end
  
  def look
    self.page_template.look
  end
  
  def page_template
    self.website.blog_page.page_template
  end
  
  def page
    self.website.blog_page
  end
  
  def complete_html(current_member)
    self.page.complete_html(current_member, self.language, { 'post' => self, 'page' => { 'title' => self.title.to_s, 'description' => self.content.to_s.gsub(/<\/?[^>]*>/, "")[0..255] } })
  end
  
end
