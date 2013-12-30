class AddSortFieldToCustomData < ActiveRecord::Migration
  def self.up
    add_column :custom_datas, :sort_field_id, :integer
    add_column :custom_datas, :sort_field_order, :boolean, :default => false
  end

  def self.down
    remove_column :custom_datas, :sort_field_order
    remove_column :custom_datas, :sort_field_id
  end
end