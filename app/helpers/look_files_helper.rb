module LookFilesHelper
  def look_file_image(file)
    unless file.filename.blank? 
      if FileTest.exists?("#{Rails.root}/public/images/extensions/file-#{File.extname(file.filename)[1..-1]}.png")
        image_tag("extensions/file-#{File.extname(file.filename)[1..-1]}.png")
      else
        image_tag("extensions/file.png")
      end
    end
  end
end
