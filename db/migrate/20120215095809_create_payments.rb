class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.boolean :paid, :default => false
      t.datetime :paid_at
      t.float :paid_price
      t.integer :order_id

      t.timestamps
    end
  end
end
