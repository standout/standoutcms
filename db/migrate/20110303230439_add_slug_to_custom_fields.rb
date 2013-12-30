class AddSlugToCustomFields < ActiveRecord::Migration
  def self.up
    add_column :custom_data_fields, :slug, :string
    
    CustomDataField.all.each do |field|
      field.update_attribute :slug, field.name_to_slug
    end
    
  end

  def self.down
    remove_column :custom_data_fields, :slug
  end
end