class CreateCustomDatas < ActiveRecord::Migration
  def self.up
    create_table :custom_datas do |t|
      t.string :title
      t.string :liquid_name
      t.integer :website_id
      t.timestamps
    end    
  end

  def self.down
    drop_table :custom_datas
  end
end