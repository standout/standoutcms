class AddNotesToCartsAndCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :notes, :text
    change_column :carts, :notes, :text
  end
end
