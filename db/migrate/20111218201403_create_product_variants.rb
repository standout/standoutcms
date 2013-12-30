class CreateProductVariants < ActiveRecord::Migration
  def change
    create_table :product_variants do |t|
      t.integer :product_id
      t.string :color
      t.string :size
      t.string :material
      t.float :price
      t.integer :inventory

      t.timestamps
    end
  end
end
