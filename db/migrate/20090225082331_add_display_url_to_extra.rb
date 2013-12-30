class AddDisplayUrlToExtra < ActiveRecord::Migration
  def self.up
    add_column :extras, :display_url, :string
  end

  def self.down
    remove_column :extras, :display_url
  end
end
