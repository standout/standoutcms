class AddIsSharedToLooks < ActiveRecord::Migration
  def self.up
    add_column :looks, :shared, :boolean, :default => false
  end

  def self.down
    remove_column :looks, :shared
  end
end
