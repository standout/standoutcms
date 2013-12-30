class AddIndexToTranslations < ActiveRecord::Migration
  def self.up
    add_index :translated_page_attributes, :language_short_code
    add_index :translated_page_attributes, :page_id
  end

  def self.down
    remove_index :translated_page_attributes, :language_short_code
    remove_index :translated_page_attributes, :page_id
  end
end
