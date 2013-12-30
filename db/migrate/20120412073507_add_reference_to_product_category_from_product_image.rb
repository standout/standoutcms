class AddReferenceToProductCategoryFromProductImage < ActiveRecord::Migration
  def change
    change_table :product_images do |t|
      t.references :product_category
    end
  end
end
