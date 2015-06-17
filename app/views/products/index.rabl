collection @products, root: false, object_root: false
attributes :id, :website_id, :title, :description, :price, :vat_percentage, :created_at,
           :updated_at, :url, :vendor_id, :deleted_at, :product_category_ids

node :thumbnail do |object|
  object.product_images.any? ? object.product_images.first.image.url(:small) : ''
end
