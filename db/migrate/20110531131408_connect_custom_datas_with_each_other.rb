class ConnectCustomDatasWithEachOther < ActiveRecord::Migration
  def self.up
    add_column :custom_data_fields, :listconnection, :integer
  end

  def self.down
    remove_column :custom_data_fields, :listconnection
  end
end