class AddPageTemplateIdToMenus < ActiveRecord::Migration
  def self.up
    add_column :menus, :page_template_id, :integer
    
    # Connect existing menus to Page Templates.
    Menu.all.each do |menu|
      begin
        menu.update_attribute :page_template_id, Look.find(menu.look_id).page_templates.first
        puts "Updating menu #{menu.id}"
      rescue
        puts "Could not update menu #{menu.id}"
      end
    end
    
  end

  def self.down
    remove_column :menus, :page_template_id
  end
end