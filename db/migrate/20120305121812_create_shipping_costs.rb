class CreateShippingCosts < ActiveRecord::Migration
  def change
    create_table :shipping_costs do |t|
      t.string :cost_type
      t.float :from_value
      t.float :to_value
      t.float :cost
      t.references :website

      t.timestamps
    end
    add_index :shipping_costs, :website_id
  end
end
