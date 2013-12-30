class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.integer :website_id
      t.text :release_notes
      t.integer :user_id

      t.timestamps
    end
    
  end
end
