class AddProductsToProductCategoriesTable < ActiveRecord::Migration
  def change
    create_table :product_categories_products, :id => false, :force => true do |t|
      t.integer :product_id
      t.integer :product_category_id
    end
  end
end