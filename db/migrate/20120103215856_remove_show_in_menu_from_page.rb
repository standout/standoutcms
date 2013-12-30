class RemoveShowInMenuFromPage < ActiveRecord::Migration
  def up
    remove_column :pages, :show_in_menu
  end

  def down
    add_column :pages, :show_in_menu, :boolean, :default => true
  end
end
