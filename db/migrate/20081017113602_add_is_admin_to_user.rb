class AddIsAdminToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false
    
    for user in User.find(:all)
      user.update_attribute :admin, true
    end
    
  end

  def self.down
    remove_column :users, :admin
  end
end
