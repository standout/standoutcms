class CreateOrders < ActiveRecord::Migration
  def change
  	
    create_table :orders do |t|
      t.integer :website_id
      t.integer :customer_id
      t.integer :cart_id
      t.timestamps
    end

    add_column :websites, :payson_api_key, :string

  end
end
