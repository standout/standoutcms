class AddProductCategoryIdToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :product_category_id, :integer
  end
end
