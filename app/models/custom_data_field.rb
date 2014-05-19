class CustomDataField < ActiveRecord::Base
  belongs_to :custom_data_list, :foreign_key => :custom_data_id
  before_save :fix_slug
  after_update :refresh_asset
  validates_presence_of :name, :fieldtype, :custom_data_id
  
  TYPES = %w{string numeric text wysiwyg image file date time datetime language checkbox listconnection listconnections title}
  
  def fix_slug
    self.slug = self.name_to_slug
  end
  
  def connected_list
    @connected_list ||= find_list
  end
  

  # Return name without strange chars
  def name_to_slug
    self.name.to_s.to_slug
  end
  
  def image_size_large
    self[:image_size_large].blank? ? "600x600" : self[:image_size_large]
  end
  
  def image_size_medium
    self[:image_size_medium].blank? ? "400x400" : self[:image_size_medium]
  end
  
  def image_size_small
    self[:image_size_small].blank? ? "200x200#" : self[:image_size_small]
  end

  # poor mans "STI"
  def image?
    fieldtype == "image"
  end
  
  private
  # reprocess images if custom data field image size is changed
  def refresh_asset
    if image? || image_size_small_changed? || image_size_medium_changed? || image_size_large_changed? # reprocess only when size attrs changed
      custom_data_list.custom_data_rows.each do |img| 
        img.pictures.each { | pic | pic.reprocess }
      end
      custom_data_list.website.servers.each do |server|
        puts server.name.to_s
        if Rails.env.development?
          puts "Notice: Since you are in development mode, we are not running server.clear_image_cache!"
        else
          server.clear_image_cache! 
        end
      end
    end
  end
  
  def find_list
    CustomDataList.find(self.listconnection) rescue false
  end
  
end
