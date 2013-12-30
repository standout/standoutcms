class CreateWebsiteMemberships < ActiveRecord::Migration
  def self.up
    create_table :website_memberships do |t|
      t.integer :user_id
      t.integer :website_id
      t.boolean :website_admin, :default => true

      t.timestamps
    end
    
    # Add existing users, and make them all admins for their own websites.
 #  User.all.each do |user|
 #    user.old_websites.each do |website|
 #      puts "WebsiteMembership: create for user #{user.id} and website #{website.id}"
 #      WebsiteMembership.create(:user_id => user.id, :website_id => website.id, :website_admin => true)
 #    end
 #  end
    
  end

  def self.down
    drop_table :website_memberships
  end
end
