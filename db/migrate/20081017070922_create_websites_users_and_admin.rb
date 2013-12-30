class CreateWebsitesUsersAndAdmin < ActiveRecord::Migration
  def self.up
    create_table :users_websites, :id => false do |t|
      t.column :user_id, :integer
      t.column :website_id, :integer
    end
  end

  def self.down
    drop_table :users_websites
  end
end
