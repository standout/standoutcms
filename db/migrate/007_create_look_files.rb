class CreateLookFiles < ActiveRecord::Migration
  def self.up
    create_table :look_files do |t|
      t.integer :look_id
      t.string :content_type
      t.string :filename

      t.timestamps
    end
  end

  def self.down
    drop_table :look_files
  end
end
