class ChangePricePerItemToFloatOnCartItem < ActiveRecord::Migration
    def up
      change_column :cart_items, :price_per_item, :float
    end

    def down
      change_column :cart_items, :price_per_item, :integer
    end
end
