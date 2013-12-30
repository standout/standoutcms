class ChangeOriginalPathToFilenameOnGalleryPhotos < ActiveRecord::Migration
  def self.up
    rename_column :gallery_photos, :original_path, :filename
    add_column :gallery_photos, :content_type, :string
  end

  def self.down
    rename_column :gallery_photos, :filename, :original_path
    remove_column :gallery_photos, :content_type
  end
end
