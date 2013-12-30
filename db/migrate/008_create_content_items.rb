class CreateContentItems < ActiveRecord::Migration
  def self.up
    create_table :content_items do |t|
      t.integer :page_id
      t.integer :parent_id
      t.string :content_type
      t.string :for_html_id
      t.integer :width
      t.integer :height
      t.text :text_content
      t.text :css
      t.string :original_filename

      t.timestamps
    end
  end

  def self.down
    drop_table :content_items
  end
end
