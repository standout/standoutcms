class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :website_id
      t.integer :customer_id
      t.string :notes

      t.timestamps
    end
    
    create_table :cart_items do |t|
      t.integer :cart_id
      t.string  :title
      t.integer :product_id
      t.integer :quantity
      t.integer :price_per_item
      t.float   :vat_percentage
       
      t.timestamps
    end
  end
end
