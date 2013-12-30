class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :website_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address_line1
      t.string :address_line2
      t.string :zipcode
      t.string :city
      t.string :phone

      t.timestamps
    end
  end
end
