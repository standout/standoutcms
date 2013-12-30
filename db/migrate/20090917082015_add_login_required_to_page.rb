class AddLoginRequiredToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :login_required, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :login_required
  end
end
