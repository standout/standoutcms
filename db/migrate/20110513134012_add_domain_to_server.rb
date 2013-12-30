class AddDomainToServer < ActiveRecord::Migration
  def self.up
    add_column :servers, :domain, :string
  end

  def self.down
    remove_column :servers, :domain
  end
end
