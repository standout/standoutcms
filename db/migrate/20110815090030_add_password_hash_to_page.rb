class AddPasswordHashToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :password_hash, :string
  end

  def self.down
    remove_column :pages, :password_hash
  end
end