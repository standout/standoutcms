class AddParentIdToProductCategories < ActiveRecord::Migration
  def change
    add_column :product_categories, :parent_id, :integer
  end
end