class AddSlugToCustomDataRow < ActiveRecord::Migration
  def change
    add_column :custom_data_rows, :slug, :string
  end
end
