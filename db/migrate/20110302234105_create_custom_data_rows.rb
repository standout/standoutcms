class CreateCustomDataRows < ActiveRecord::Migration
  def self.up
    create_table :custom_data_rows do |t|
      t.integer :custom_data_id
      t.text :json
      t.timestamps
    end
    
    add_column :custom_data_fields, :custom_data_id, :integer
  end

  def self.down
    remove_column :custom_data_fields, :custom_data_id
    drop_table :custom_data_rows
  end
end