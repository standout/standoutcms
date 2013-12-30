class CreateContactInformationSets < ActiveRecord::Migration
  def change
    create_table :contact_information_sets do |t|
      t.string :information_type, default: 'customer'
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :vat_identification_number
      t.string :address_line1
      t.string :address_line2
      t.string :zipcode
      t.string :city
      t.string :phone
      t.references :order

      t.timestamps
    end
    add_index :contact_information_sets, :order_id
  end
end
