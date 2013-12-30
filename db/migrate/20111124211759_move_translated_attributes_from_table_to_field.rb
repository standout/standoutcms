class MoveTranslatedAttributesFromTableToField < ActiveRecord::Migration
  def up
    add_column :pages, :translated_attributes_data, :text
    
    # Move all data from translation table to data field
    Page.all.each do |page|
      puts "Updating page #{page.id}"
      TranslatedPageAttribute.where(:page_id => page.id).each do |tpa|
        puts " - updating #{tpa.attribute_name} = #{tpa.attribute_value}"
        page.store_translated_attributes(tpa.attribute_name, tpa.attribute_value, tpa.language_short_code)
      end
      page.save
    end
    
  end

  def down
    remove_column :pages, :translated_attributes_data
  end
end