class RemoveLimitFromNotesOnCarts < ActiveRecord::Migration
  def change
    change_column :carts, :notes, :text, limit: nil
  end
end
