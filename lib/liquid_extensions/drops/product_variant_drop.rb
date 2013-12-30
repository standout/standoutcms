class ProductVariantDrop < Liquid::Drop
  def initialize(product, variant)
    @product = product
    @variant = variant
  end
  
  def product
    @product
  end
  
  def price
    @variant.price
  end
  
  def price_including_tax
    self.price + self.tax
  end
  
  def tax
    @variant.price.to_f * @product.vat_percentage * 0.01
  end
  
  def id
    @variant.id
  end
  
  def material
    @variant.material
  end
  
  def color
    @variant.color
  end
  
  def size
    @variant.size
  end
  
  def description
    [@variant.size, @variant.material, @variant.color].collect{ |d| d.to_s == "" ? nil : d }.compact.join(", ")
  end
  
end