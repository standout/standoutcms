class CreateServers < ActiveRecord::Migration
  def self.up
    create_table :servers do |t|
      t.integer :website_id
      t.integer :order, :default => 0
      
      t.string :name
      t.string :host
      t.string :username
      t.string :password
      t.string :publish_dir

      t.timestamps
    end
  end

  def self.down
    drop_table :servers
  end
end
