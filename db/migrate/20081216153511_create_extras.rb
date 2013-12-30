class CreateExtras < ActiveRecord::Migration
  def self.up
    create_table :extras do |t|
      t.string :name
      t.string :edit_url
      t.boolean :public, :default => true
      t.integer :website_id
      
      t.timestamps
    end
    
    create_table :extras_websites, :id => false do |t|
      t.integer :extra_id
      t.integer :website_id
    end
    
  end

  def self.down
    drop_table :extras
    drop_table :extras_websites
  end
end
