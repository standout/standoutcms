class AddProductIdToUrlPointers < ActiveRecord::Migration
  def change
    add_column :url_pointers, :product_id, :integer
    add_column :url_pointers, :product_category_id, :integer
  end
end