class AddDisplayInListToCustomDataField < ActiveRecord::Migration
  def self.up
    add_column :custom_data_fields, :display_in_list, :boolean, :default => true
  end

  def self.down
    remove_column :custom_data_fields, :display_in_list
  end
end