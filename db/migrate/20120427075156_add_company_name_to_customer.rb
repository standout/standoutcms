class AddCompanyNameToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :company_name, :string
  end
end
