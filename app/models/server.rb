require "#{Rails.root}/lib/standout_ftp"

class Server < ActiveRecord::Base
  include Standout::Ftp
  belongs_to :website

  def root_publish_dir
    if self.root_url.to_s.length <= 1
      self.publish_dir
    else
      self.publish_dir.gsub("#{self.root_url.to_s}", '')
    end
  end

  def changed_pages
    self.website.pages.where("updated_at >= ?", self.last_published_to)
  end

  def images_dir
    [publish_dir, "images"].join("/")
  end

  def clear_image_cache!
    connect
    go_to(images_dir)
    files.each do |file|
      remove(file) unless file == "cache.php"
    end
    disconnect
  end

end
