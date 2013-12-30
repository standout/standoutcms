class AddVariantIdToCartItem < ActiveRecord::Migration
  def change
  	add_column :cart_items, :product_variant_id, :integer
  end
end
