class AddTypeManagementToDynamicAttributes < ActiveRecord::Migration
  def up
    add_column :product_property_keys,   :data_type, :string
    add_column :product_property_values, :string,    :string
    add_column :product_property_values, :integer,   :integer

    remove_column :product_property_values, :value
  end

  def down
    remove_column :product_property_keys,   :type
    remove_column :product_property_values, :string
    remove_column :product_property_values, :integer

    add_column :product_property_values, :value, :string
  end
end
