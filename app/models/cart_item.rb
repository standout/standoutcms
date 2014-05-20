class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product
  belongs_to :product_variant

  before_create :set_unset_attrs, :generate_api_key

  def price
    self.quantity.to_f * self.price_per_item.to_f
  end

  def price_including_tax
    self.price + self.tax
  end

  def price_per_item_including_tax
     self.price_per_item.to_f * (self.vat_percentage.to_f / 100 + 1)
  end

  def tax
    self.price * self.vat_percentage * 0.01
  end

  def set_unset_attrs
    attrs = {
      title:          product.title,
      price_per_item: product.price,
      vat_percentage: product.vat_percentage
    }

    attrs.each do |attr, value|
      self.send("#{attr}=", value) unless self.send("#{attr}")
    end
  end

  def generate_api_key
    self.api_key = SecureRandom.hex(16)
  end
end
