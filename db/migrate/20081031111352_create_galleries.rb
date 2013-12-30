class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.integer :website_id
      t.integer :content_item_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :galleries
  end
end
