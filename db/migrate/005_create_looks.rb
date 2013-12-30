class CreateLooks < ActiveRecord::Migration
  def self.up
    create_table :looks do |t|
      t.string :title
      t.integer :website_id
      t.text :html
      t.integer :pages_count

      t.timestamps
    end
  end

  def self.down
    drop_table :looks
  end
end
