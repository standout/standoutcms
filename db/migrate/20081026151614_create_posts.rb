class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.boolean :allow_comments, :default => true
      t.integer :website_id
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
