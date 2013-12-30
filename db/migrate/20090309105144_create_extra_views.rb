class CreateExtraViews < ActiveRecord::Migration
  def self.up
    create_table :extra_views do |t|
      t.integer :extra_id
      t.string :name
      t.string :url

      t.timestamps
    end
    
    add_column :content_items, :extra_view_id, :integer
  end

  def self.down
    remove_column :content_items, :extra_view_id
    drop_table :extra_views
  end
end
