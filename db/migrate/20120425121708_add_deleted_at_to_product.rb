class AddDeletedAtToProduct < ActiveRecord::Migration
  def change
    add_column :products, :deleted_at, :timestamp
  end
end
