class Gallery < ActiveRecord::Base
    
  has_many :gallery_photos, :dependent => :destroy
  belongs_to :website
  belongs_to :content_item
  before_create :check_website
  after_save :set_default_liquid_template
  after_update :touch_page
  
  STYLES = %w{default rotate layoutimage}
  
  # Make sure it does belong to a website
  def check_website
    self.website_id = self.content_item.page.website_id if self.website_id.nil?
  rescue
    nil
  end
  
  # The page should be mark as updated
  def touch_page
    self.content_item.page.save rescue nil
  end
  
  def set_default_liquid_template
    if self.liquid.to_s == ''
      self.update_attribute(:liquid, File.read("#{Rails.root}/lib/liquid_templates/galleries/default.liquid"))
    end
  end
  
  def to_liquid
    { "id" => self.id.to_s, "title" => self.title.to_s, "images" => self.gallery_photos }
  end
  
  def large_size
    self[:large_size].to_s == '' ? '800x600>' : self[:large_size]
  end
  
  def thumbnail_size
    self[:thumbnail_size].to_s == '' ? '100x100#' : self[:thumbnail_size]
  end

  def content
    set_default_liquid_template
	  begin
	    t = Liquid::Template.parse(self.liquid.to_s)
	    t.render({"gallery" => self })
		rescue => e
		  "<h2>Gallery: Liquid parsing error</h2>\n<p>#{e.message}</p>"
		end
  end

end
