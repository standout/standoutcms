class AddOrderToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :position, :integer, :default => 0
    add_column :pages, :parent_id, :integer
  end

  def self.down
    remove_column :pages, :position
    remove_column :pages, :parent_id
  end
end
