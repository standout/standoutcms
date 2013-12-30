class AddPageTemplateIdToDataField < ActiveRecord::Migration
  def self.up
    add_column :custom_datas, :page_template_id, :integer
  end

  def self.down
    remove_column :custom_datas, :page_template_id
  end
end