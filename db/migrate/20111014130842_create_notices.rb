class CreateNotices < ActiveRecord::Migration
  def self.up
    create_table :notices do |t|
      t.integer :user_id
      t.integer :website_id
      t.integer :page_id
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :notices
  end
end
