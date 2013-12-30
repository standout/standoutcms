class AddLookIdToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :look_id, :integer
  end

  def self.down
    remove_column :pages, :look_id
  end
end
