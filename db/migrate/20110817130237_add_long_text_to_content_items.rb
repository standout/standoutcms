class AddLongTextToContentItems < ActiveRecord::Migration
  def self.up
    change_column :content_items, :text_content, :longtext
  end

  def self.down
    change_column :content_items, :text_content, :text
  end
end
