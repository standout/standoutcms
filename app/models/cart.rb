class Cart < ActiveRecord::Base
  has_many :cart_items, :dependent => :destroy
  belongs_to :website

  has_one :order

  before_create :generate_api_key

  attr_accessible :website_id

  # Add a new cart item or increment if this product
  # is already in the cart.
  def add(product, quantity = 1, product_variant = nil, notes = nil)
    variant_id = product_variant.nil? ? nil : product_variant.id
    existing_item = self.cart_items.where(:product_id => product.id, :product_variant_id => variant_id).first
    if existing_item.blank?
      price = product_variant ? product_variant.price : product.price
      CartItem.create(:notes => notes, :cart_id => self.id, :product_variant_id => variant_id, :product_id => product.id, :title => product.title, :quantity => quantity, :price_per_item => price, :vat_percentage => product.vat_percentage)
    else
      existing_item.update_attribute(:quantity, existing_item.quantity + quantity)
    end
  end

  def update_cart(product, quantity = 0, product_variant = nil, notes = nil)
    variant_id = product_variant.nil? ? nil : product_variant.id
    return unless product
    item = self.cart_items.where(:product_id => product.id, :product_variant_id => variant_id).first
    if item.blank?
      add(product, quantity, product_variant, notes) if quantity > 0
    else
      if quantity > 0
        item.quantity = quantity
        item.notes = notes
        item.save
      else
        item.destroy
      end
    end
  end

  def empty
    cart_items.destroy_all
  end

  def total_items_count
    self.cart_items.sum(:quantity)
  end

  def total_price
    cart_items.collect{ |item| item.price }.sum
  end

  def total_price_including_tax
    cart_items.collect{ |item| item.price_including_tax }.sum
  end

  # Returns the shipping cost for the cart. At the moment, the shipping cost
  # depends on the total price (including tax) and the shipping cost ranges for
  # the current website. This has to be generalized.
  #
  # If it finds more than one matching shipping costs, it returns the one with
  # the highest value.
  def shipping_cost
    return 0 if cart_items.empty?
    website.get_matching_shipping_costs(total_price_including_tax)
      .reduce(0){ |m, v| m > v ? m : v }
  end

  def paypal_url(return_url, notify_url)
    values = {
      :business => self.website.paypal_business_email,
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :notify_url => notify_url,
      :invoice => self.order.id,
      :currency_code => self.website.webshop_currency
    }

    values.merge!(
      'amount_1'      => shipping_cost,
      'item_name_1'   => 'Shipping cost',
      'item_number_1' => 'shipping_cost',
      'quantity_1'    => 1
    )

    self.cart_items.each_with_index do |item, index|
      product = item.product
      values.merge!({
        "amount_#{index+2}" => item.price_including_tax,
        "item_name_#{index+2}" => product.title,
        "item_number_#{index+2}" => product.id,
        "quantity_#{index+2}" => item.quantity
      })
    end

    if self.website.webshop_live == '1'
      "https://www.paypal.com/cgi-bin/webscr?" + values.to_query
    else
      "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
    end
  end

  def generate_api_key
    self.api_key = SecureRandom.hex(16)
  end
end
