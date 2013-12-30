class AddSettingsToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :settings, :text

  end
end
