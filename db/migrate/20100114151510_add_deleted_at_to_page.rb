class AddDeletedAtToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :deleted, :boolean, :default => false
    add_column :content_items, :deleted, :boolean, :default => false
  end

  def self.down
    remove_column :content_items, :deleted
    remove_column :pages, :deleted
  end
end
