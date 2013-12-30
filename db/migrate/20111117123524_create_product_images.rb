class CreateProductImages < ActiveRecord::Migration
  def up
    create_table :product_images, :force => true do |t|
      t.integer :product_id
      t.integer :website_id
      t.integer :position, :default => 0
      t.string  :image_file_name
      t.string  :image_content_type
      t.integer :image_file_size
      t.integer :image_uploaded_at, :datetime
      t.timestamps
    end
  end

  def down
    drop_table :product_images
  end
end