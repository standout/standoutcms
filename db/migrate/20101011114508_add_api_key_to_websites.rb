class AddApiKeyToWebsites < ActiveRecord::Migration
  def self.up
    add_column :websites, :api_key, :string
  end

  def self.down
    remove_column :websites, :api_key
  end
end
