class AddRootUrlToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :root_url, :string
  end

  def self.down
    remove_column :servers, :root_url
  end
end
