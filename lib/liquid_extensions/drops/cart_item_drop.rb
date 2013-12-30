# This tightly connected to CartItem and used to output data in liquid templates.
class CartItemDrop < Liquid::Drop

  def initialize(item)
    @item = item
  end

  def price
    @item.price.to_f
  end

  def price_including_tax
    @item.price_including_tax
  end

  def notes
    @item.notes.to_s
  end

  def price_per_item
    @item.price_per_item.to_f
  end

  def price_per_item_including_tax
    @item.price_per_item_including_tax
  end

  def product
    ProductDrop.new(@item.product)
  end

  def quantity
    @item.quantity.to_i
  end

  def tax
    @item.tax
  end

  def title
    @item.title
  end

  def variant
    @item.product_variant.nil? ? nil : ProductVariantDrop.new(@item.product, @item.product_variant)
  end

  def vat_percentage
    @item.vat_percentage
  end

end
