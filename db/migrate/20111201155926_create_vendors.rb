class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.integer :website_id
      t.string :name

      t.timestamps
    end
    
    add_column :products, :vendor_id, :integer
    
  end
end