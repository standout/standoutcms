class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :website_id
      t.string :title
      t.text :description
      t.float :price
      t.float :vat_percentage

      t.timestamps
    end
  end
end
