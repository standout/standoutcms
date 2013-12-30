class AddApiKeyToCartAndCartItem < ActiveRecord::Migration
  def change
    add_column :carts, :api_key, :string
    add_column :cart_items, :api_key, :string
  end
end
