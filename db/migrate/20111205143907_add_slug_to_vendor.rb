class AddSlugToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :slug, :string
    add_column :url_pointers, :vendor_id, :integer
  end
end