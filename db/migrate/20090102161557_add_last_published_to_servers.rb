class AddLastPublishedToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :last_published_to, :datetime
  end

  def self.down
    remove_column :servers, :last_published_to
  end
end
