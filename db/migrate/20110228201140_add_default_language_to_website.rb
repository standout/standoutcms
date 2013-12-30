class AddDefaultLanguageToWebsite < ActiveRecord::Migration
  def self.up
    add_column :websites, :default_language, :string
  end

  def self.down
    remove_column :websites, :default_language
  end
end