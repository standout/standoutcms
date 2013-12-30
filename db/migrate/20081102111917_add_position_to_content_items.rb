class AddPositionToContentItems < ActiveRecord::Migration
  def self.up
    add_column :content_items, :position, :integer, :default => 0
  end

  def self.down
    remove_column :content_items, :position
  end
end
