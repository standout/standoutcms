require "fileutils"
class LookFile < ActiveRecord::Base
  belongs_to :look
  after_destroy :remove_file

  attr_accessible :content, :filename, :text_content
  
  def remove_file
    File.delete("#{Rails.root}/public/#{path}") rescue nil
  end
  
  def text_content
    File.read(complete_path) rescue ''
  end
  
  def text_content=(text)
    File.open(self.complete_path, "wb") do |f| 
      f.write(text)
    end
  end
  
  def directory
    "/files/looks/#{self.look_id}"
  end

  def extension
    filename.split(".")[-1]
  end
  
  def path
    directory + "/" + self.filename
  rescue
    self.destroy
    "removed_file_#{self.id}.tmp"
  end
  
  def complete_path
    "#{Rails.root}/public/#{path}"
  end
  
  def copy_to(thelook)
    new_copy = LookFile.create(:look_id => thelook.id, :filename => self.filename, :content_type => self.content_type)
    if File.exists?(complete_path)
      path = "#{Rails.root}/public/#{new_copy.directory}/"
      FileUtils.mkdir_p path
      logger.info "Copy from #{self.complete_path} to #{new_copy.complete_path}"
      File.copy(self.complete_path, new_copy.complete_path)
      
    end
  end
  
end
