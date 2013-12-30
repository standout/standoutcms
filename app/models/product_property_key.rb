class ProductPropertyKey < ActiveRecord::Base
  has_many :product_property_values, dependent: :destroy
  belongs_to :website
end
