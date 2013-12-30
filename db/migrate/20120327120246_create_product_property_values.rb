class CreateProductPropertyValues < ActiveRecord::Migration
  def change
    create_table :product_property_values do |t|
      t.string :value
      t.references :product_property_key
      t.references :product_variant
      t.references :product

      t.timestamps
    end
    add_index :product_property_values, :product_property_key_id
    add_index :product_property_values, :product_variant_id
    add_index :product_property_values, :product_id
  end
end
