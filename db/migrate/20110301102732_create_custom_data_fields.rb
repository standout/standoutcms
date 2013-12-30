class CreateCustomDataFields < ActiveRecord::Migration
  def self.up
    create_table :custom_data_fields do |t|
      t.string :name
      t.string :fieldtype
      t.timestamps
    end
  end

  def self.down
    drop_table :custom_data_fields
  end
end
