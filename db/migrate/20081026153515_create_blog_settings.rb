class CreateBlogSettings < ActiveRecord::Migration
  def self.up
    create_table :blog_settings do |t|
      t.integer :type
      t.integer :content_item_id
      t.integer :number_of_posts_to_display
      t.boolean :allow_comments, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :blog_settings
  end
end
