class AddEnglishAttributesToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :english_title, :string
    add_column :content_items, :language, :string

    for item in ContentItem.find(:all)
      item.update_attribute :language, "sv"
    end
  end

  def self.down
    remove_column :content_items, :language
    remove_column :pages, :english_title
  end
end
