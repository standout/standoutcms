class AddEmailToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :email, :string

  end
end
