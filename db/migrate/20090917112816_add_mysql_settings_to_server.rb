class AddMysqlSettingsToServer < ActiveRecord::Migration
  def self.up
    add_column :servers, :mysql_host, :string
    add_column :servers, :mysql_database, :string
    add_column :servers, :mysql_username, :string
    add_column :servers, :mysql_password, :string
  end

  def self.down
    remove_column :servers, :mysql_password
    remove_column :servers, :mysql_username
    remove_column :servers, :mysql_database
    remove_column :servers, :mysql_host
  end
end
