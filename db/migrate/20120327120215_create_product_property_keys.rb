class CreateProductPropertyKeys < ActiveRecord::Migration
  def change
    create_table :product_property_keys do |t|
      t.string :name
      t.string :slug
      t.references :website

      t.timestamps
    end
    add_index :product_property_keys, :website_id
  end
end
