class AddStickyToContentItem < ActiveRecord::Migration
  def self.up
    add_column :content_items, :sticky, :boolean, :default => false
  end

  def self.down
    remove_column :content_items, :sticky
  end
end
