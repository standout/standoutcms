class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :website_id
      t.string :title
      t.string :address

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
