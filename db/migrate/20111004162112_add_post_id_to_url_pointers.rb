class AddPostIdToUrlPointers < ActiveRecord::Migration
  def self.up
    add_column :url_pointers, :post_id, :integer
  end

  def self.down
    remove_column :url_pointers, :post_id
  end
end