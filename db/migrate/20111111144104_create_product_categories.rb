class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.integer :website_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
