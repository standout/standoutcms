class Look < ActiveRecord::Base
  has_many :look_files, -> { order 'filename asc' }, :dependent => :destroy
  belongs_to :website
  before_update :link_to_files
  before_create :make_sure_it_is_not_shared
  has_many :page_templates

  # =================
  # = Class Methods =
  # =================

  def copy_files_to(look)
    for file in self.look_files
      file.copy_to(look)
    end
  end

  def make_sure_it_is_not_shared
    #self.shared = false
  end

  # Files referred in the HTML source should be pointed to our correct look files.
  def link_to_files
    doc = Hpricot(self.html.to_s)

    # Find all images
    (doc/"img").each do |img|
       src = img.attributes['src']
       path = src.split(/\//).pop

       look_file = self.look_files.find(:first, :conditions => ["filename = ?", path])
       unless look_file.blank?
         begin
           img.raw_attributes = img.attributes.merge("src" => look_file.path)
         rescue => e
           logger.info "Look.rb line 35: #{e.inspect}"
         end
       end
     end
    self.html = doc.to_original_html
  rescue
    self.html
  end

  # ====================
  # = Instance Methods =
  # ====================

  # The preview? method decides if a Look model contains a preview.png image
  # If so, the LookFile object is return, otherwise, false
  def preview?
    self.look_files.each do |file|
      return file if file.filename == 'preview.png'
    end

    return false
  end

  def html
    self.page_templates.first.html rescue self[:html]
  end

  # returns the image for this look instance
  def image_path
    "/files/looks/#{self.id}"
  end

  def directory
    "#{Rails.root}/public/files/looks/#{self.id}"
  end

  # returns the preview path of the file, or the default preview path
  def preview_path
    if preview = self.preview?
      return preview.path
    end
    "/assets/template_preview_missing.png"
  end
end
