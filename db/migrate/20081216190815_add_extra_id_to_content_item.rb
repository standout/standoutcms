class AddExtraIdToContentItem < ActiveRecord::Migration
  def self.up
    add_column :content_items, :extra_id, :integer
  end

  def self.down
    remove_column :content_items, :extra_id
  end
end
