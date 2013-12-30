class CreateTranslatedPageAttributes < ActiveRecord::Migration
  def self.up
    create_table :translated_page_attributes do |t|
      t.integer :page_id
      t.string :language_short_code
      t.string :attribute_name
      t.string :attribute_value
      t.timestamps
    end

    # Translate all existing pages' Title And Address
    Page.find(:all).each do |page|
      TranslatedPageAttribute.create(:page_id => page.id, :language_short_code => 'sv', :attribute_name => 'title', :attribute_value => page.title)
      TranslatedPageAttribute.create(:page_id => page.id, :language_short_code => 'en', :attribute_name => 'title', :attribute_value => page.english_title) unless page.english_title.blank?
      TranslatedPageAttribute.create(:page_id => page.id, :language_short_code => 'se', :attribute_name => 'address', :attribute_value => page.address) unless page.address.blank?
      TranslatedPageAttribute.create(:page_id => page.id, :language_short_code => 'en', :attribute_name => 'address', :attribute_value => page.english_address) unless page.english_address.blank?
    end

  end

  def self.down
    drop_table :translated_page_attributes
  end
end
