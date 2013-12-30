class AddSlugToBlogposts < ActiveRecord::Migration
  def self.up
    add_column :posts, :slug, :string
    add_column :posts, :language, :string
    
  end

  def self.down
    remove_column :posts, :language
    remove_column :posts, :slug
  end
end