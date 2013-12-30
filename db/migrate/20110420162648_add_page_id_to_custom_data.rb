class AddPageIdToCustomData < ActiveRecord::Migration
  def self.up
    add_column :custom_datas, :page_id, :integer
  end

  def self.down
    remove_column :custom_datas, :page_id
  end
end