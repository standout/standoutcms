class CartDrop < Liquid::Drop

  def initialize(cart_id)
    @cart = Cart.find(cart_id)
  rescue
    @cart = Cart.new
  end

  def items
    @cart.cart_items.collect{ |i| CartItemDrop.new(i) }
  end

  def has_items?
    !@cart.cart_items.empty?
  end

  def total_items_count
    @cart.cart_items.size
  end

  def total_price
    @cart.total_price
  end

  def total_price_including_tax
    @cart.total_price_including_tax
  end

  def shipping_cost
    @cart.shipping_cost
  end

  def total_tax
    @cart.total_tax
  end

  def api_key
    @cart.api_key.to_s
  end

  def notes
    @cart.notes
  end
end
