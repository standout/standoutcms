class AddLiquidToGallery < ActiveRecord::Migration
  def self.up
    add_column :galleries, :liquid, :text
  end

  def self.down
    remove_column :galleries, :liquid
  end
end