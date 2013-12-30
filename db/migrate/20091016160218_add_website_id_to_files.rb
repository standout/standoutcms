class AddWebsiteIdToFiles < ActiveRecord::Migration
  def self.up
    add_column :assets, :website_id, :integer
    add_index "assets", ["user_id"], :name => "asset_website"
  end

  def self.down
    remove_column :assets, :website_id
  end
end
