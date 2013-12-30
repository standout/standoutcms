class CreateAllowedPages < ActiveRecord::Migration
  def self.up
    create_table :allowed_pages do |t|
      t.integer :page_id
      t.integer :user_id
      t.integer :website_membership_id
      t.timestamps
    end
    
    add_column :website_memberships, :restricted_user, :boolean, :default => false
  end

  def self.down
    remove_column :website_memberships, :restricted_user
    drop_table :allowed_pages
  end
end