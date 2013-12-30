class CreateUrlPointers < ActiveRecord::Migration
  def self.up
    create_table :url_pointers do |t|
      t.string :path
      t.integer :website_id
      t.integer :page_id
      t.string :language
      t.integer :custom_data_row_id

      t.timestamps
    end
    
    add_index :content_items, :page_id
    add_index :content_items, :for_html_id
    add_index :content_items, :language
        
  end

  def self.down
    remove_index :content_items, :language
    remove_index :content_items, :for_html_id
    remove_index :content_items, :page_id

    drop_table :url_pointers
  end
end