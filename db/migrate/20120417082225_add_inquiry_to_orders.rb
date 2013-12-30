class AddInquiryToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :inquiry, :boolean, default: false
  end
end
