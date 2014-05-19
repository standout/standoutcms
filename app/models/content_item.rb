class ContentItem < ActiveRecord::Base
  after_create :create_blog_setting
  has_one :blog_setting
  has_one :gallery
  belongs_to :page
  acts_as_list
  after_destroy :remove_gallery, :remove_stickies
  before_save :set_default_language
  after_save :touch_page
  belongs_to :extra
  belongs_to :extra_view
  default_scope { where("deleted = ?", false) }

  def touch_page
    self.page.touch
  end

  def self.find_with_destroyed *args
    self.with_exclusive_scope { find(*args) }
  end

  def content
    stuff = { 'language' => self.language, 'id' => self.page_id, 'website' => WebsiteDrop.new(self.page.website) }
	  self.page.website.custom_data_lists.each do |custom_data|
		  stuff["#{custom_data.liquid_name}"] = custom_data
	  end
	  begin
		  t = Liquid::Template.parse(self[:text_content].to_s)
		  t.render(stuff)
		rescue => e
		  "<h2>32: Liquid parsing error</h2>\n<p>#{e.message}</p>"
		end
  end

  # Override delete method to avoid complete deletion, and keep
  # the regular destroy method.
  alias_method :regular_destroy, :destroy
  def destroy
    self.update_attribute :deleted, true
    self
  end

  def set_default_language
    self.language = "sv" if self.language.nil? || self.language.blank?
  end

  def remove_stickies
    if self.sticky == true
      for item in ContentItem.find(:all, :conditions => ["parent_id = ?", self.id])
        item.destroy
      end
    end
  end

  def check_for_stickies
    if self.sticky == true
      if self.parent_id.blank?
        self.update_stickies
      else
        parent = ContentItem.find(self.parent_id)
        parent.update_attribute(:text_content, self.text_content)
        parent.update_attribute(:extra_id, self.extra_id)
        parent.update_attribute(:extra_view_id, self.extra_view_id)
        parent.update_stickies
      end
    end
  end

  # Stickies!
  def update_stickies
    if self.sticky == true

      # Make sure one exists for each page
      # We might want to do this more effective later on by finding all contentItems directly instead
      # of looking for the page.
      for page in self.page.website.pages.find(:all, :conditions => ["id != ?", self.page_id])
        if self.parent_id.blank? || self.parent_id.nil? || self.parent_id.to_i == 0
          stickycopy = ContentItem.find(:first, :conditions => ["parent_id = ? and page_id = ? and language = ?", self.id, page.id, self.language])
        else
          stickycopy = ContentItem.find(:first, :conditions => ["parent_id = ? and page_id = ? and language = ?", self.parent_id, page.id, self.language])
        end
        if stickycopy.blank?
          ContentItem.create(:extra_id => self.extra_id, :sticky => true, :content_type => self.content_type, :page_id => page.id, :parent_id => self.id, :language => self.language, :text_content => self.text_content, :for_html_id => self.for_html_id, :extra_view_id => self.extra_view_id)
        else
          stickycopy.update_attribute(:text_content, self.text_content)
          stickycopy.update_attribute(:extra_id, self.extra_id)
          stickycopy.update_attribute(:extra_view_id, self.extra_view_id)
        end
      end
    end
  end

  # Replace Amazon S3 search paths with internal ones.
  # TODO: this is no longer needed in CMS3. Just commented out for now.
  def replace_image_paths
  #  self.content.to_s.gsub(/http\:\/\/s3.amazonaws.com\/standoutcms\/pictures\/(\d{2,10})\/content\/(\w{0,30})\.(png|jpg|jpeg|gif|bmp)/, '/images/\1_cached_\2_image.\3')
  #rescue
    self.content.to_s
  end

  # Try to add the class 'selected' to all links that are internal, if possible.
  def add_selected_class_to_internal_links(text_and_html)
    content = Hpricot(text_and_html)
    the_link = self.page.address(self.language.to_s)
    content.search("//a[@href*=#{the_link}]").add_class("selected")
    doc.to_original_html
  rescue
    text_and_html.to_s
  end

  # scope_condition for acts_as_list
  def scope_condition
    if for_html_id
      "page_id = #{page_id} AND #{self.class.connection.quote_column_name("for_html_id")} = '#{self.class.connection.quote_string(for_html_id.to_s)}'"
    end
  end

  # If this is a content item that holds blog posts we should create the blog settings as well
  def create_blog_setting
    if self.content_type.to_s == 'blog'
      if self.blog_setting.nil?
        BlogSetting.create(:content_item_id => self.id)
      end
    end
  end

  # Removes the associated gallery so we don't have any stale photos
  def remove_gallery
    if self.content_type.to_s == "gallery"
      Gallery.find_by_content_item_id(self.id).destroy rescue nil
    end
  end

  # Only used with plugins/extras
  def display_url
    unless self.extra_view_id.nil?
      self.extra_view.url rescue "fel.html"
    else
      self.extra.display_url rescue "fel.html"
    end
  end

  # Returns HTML to use in publishing mode for this content item
  def produce_output
    if self.content_type.to_s == "gallery"
      self.gallery.content
    elsif self.content_type.to_s == "plugin" || self.content_type.to_s == "remote"
      if self.display_url.to_s.match(/http/)
        #{}"<?php echo file_get_contents(\"#{self.display_url}\"); ?>" rescue ''
        begin
          return open(self.display_url.to_s).read
        rescue
          "<!-- failed to open #{self.display_url} -->"
        end
      else
        "<!-- #{self.display_url} - should start with http:// if you would like this to work. -->"
      end
    else
      # self.add_selected_class_to_internal_links(self.replace_image_paths.to_s).to_s
      self.replace_image_paths.to_s
    end
  end

end
