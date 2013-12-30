class AddDirectLinkToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :direct_link, :string
  end

  def self.down
    remove_column :pages, :direct_link
  end
end