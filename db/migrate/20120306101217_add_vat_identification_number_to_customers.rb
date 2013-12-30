class AddVatIdentificationNumberToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :vat_identification_number, :string
  end
end
