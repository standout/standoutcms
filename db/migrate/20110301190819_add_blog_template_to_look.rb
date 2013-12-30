class AddBlogTemplateToLook < ActiveRecord::Migration
  def self.up
    add_column :looks, :blogentry, :text
    add_column :pages, :blogentry, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :blogentry
    remove_column :looks, :blogentry
  end
end