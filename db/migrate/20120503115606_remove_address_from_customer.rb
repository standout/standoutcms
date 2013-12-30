class RemoveAddressFromCustomer < ActiveRecord::Migration
  def change
    remove_column :customers, :first_name
    remove_column :customers, :last_name
    remove_column :customers, :company_name
    remove_column :customers, :vat_identification_number
    remove_column :customers, :address_line1
    remove_column :customers, :address_line2
    remove_column :customers, :zipcode
    remove_column :customers, :city
    remove_column :customers, :phone
  end
end
