class AddCustomDataRowIdToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :custom_data_row_id, :integer
    add_column :assets, :custom_data_field_id, :integer
  end

  def self.down
    remove_column :assets, :custom_data_field_id
    remove_column :assets, :custom_data_row_id
  end
end