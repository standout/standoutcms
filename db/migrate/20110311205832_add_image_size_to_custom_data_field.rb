class AddImageSizeToCustomDataField < ActiveRecord::Migration
  def self.up
    add_column :custom_data_fields, :image_size_small, :string
    add_column :custom_data_fields, :image_size_medium, :string
    add_column :custom_data_fields, :image_size_large, :string
  end

  def self.down
    remove_column :custom_data_fields, :image_size_large
    remove_column :custom_data_fields, :image_size_small
    remove_column :custom_data_fields, :image_size_medium
  end
end