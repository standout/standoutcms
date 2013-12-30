class AddResellerToCart < ActiveRecord::Migration
  def change
    add_column :carts, :reseller, :string
  end
end
