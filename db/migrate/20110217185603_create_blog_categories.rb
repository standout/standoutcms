class CreateBlogCategories < ActiveRecord::Migration
  def self.up
    create_table :blog_categories do |t|
      t.integer :website_id
      t.string :name
      t.timestamps
    end
    
    add_column :posts, :blog_category_id, :integer
    
  end

  def self.down
    remove_column :posts, :blog_category_id
    drop_table :blog_categories
  end
end