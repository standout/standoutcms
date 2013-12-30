class ProductPropertyValue < ActiveRecord::Base
  belongs_to :product_property_key
  belongs_to :product_variant
  belongs_to :product
end
