class AddPaperclipToGalleryPhotos < ActiveRecord::Migration
  def self.up
    add_column :gallery_photos, :photo_file_name,    :string
    add_column :gallery_photos, :photo_content_type, :string
    add_column :gallery_photos, :photo_file_size,    :integer
    add_column :gallery_photos, :photo_updated_at,   :datetime
    
    add_column :galleries, :thumbnail_size, :string
    add_column :galleries, :large_size, :string
    
    # Migrate old gallery photos
    GalleryPhoto.all.each do |gp|
      begin
          puts "Saving photo #{gp.id}"
          gp.photo = File.new("#{Rails.root}/public/files/uploads/#{gp.gallery.website_id}/#{gp.id}_original.jpg")
          gp.save
          puts "Done!"
      rescue => e
        puts "ERROR: #{e}"
      end
    end
    
  end

  def self.down
    remove_column :galleries, :large_size
    remove_column :galleries, :thumbnail_size
    remove_column :gallery_photos, :photo_file_name
    remove_column :gallery_photos, :photo_content_type
    remove_column :gallery_photos, :photo_file_size
    remove_column :gallery_photos, :photo_updated_at
  end
end