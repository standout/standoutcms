class ProductVariant < ActiveRecord::Base
  include DynamicAttributes

  has_many :product_property_values
  belongs_to :product

  attr_protected :updated_at

  def as_json(opts = {})
    attributes.merge dynamic_attributes
  end

  def countdown_inventory(value)
    return unless self.inventory
    update_attribute :inventory, self.inventory - value
  end

  def website
    product.website if product
  end

  # Return a textual description of this product variant for use in e-mail views
  def description
    [color, size, material].compact.join(" ")
  end
end
