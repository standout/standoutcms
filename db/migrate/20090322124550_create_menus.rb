class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.integer :look_id
      t.string :for_html_id
      t.integer :levels, :default => 1
      t.integer :start_level, :default => 0
      t.boolean :show_submenus, :default => false

      t.timestamps
    end
    
    add_column :pages, :level, :integer
    
    # Update all existing pages with a level
    for page in Page.find(:all)
      page.save!
    end
  end

  def self.down
    remove_column :pages, :level
    drop_table :menus
  end
end
