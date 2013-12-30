class AddTitleToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :title, :string
  end

  def self.down
    remove_column :assets, :title
  end
end