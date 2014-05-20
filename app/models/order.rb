class Order < ActiveRecord::Base
  has_many :contact_information_sets
  belongs_to :customer
  belongs_to :cart, :dependent => :destroy
  belongs_to :website
  has_one    :payment, :dependent => :destroy

  validates_presence_of :website_id
  validates_presence_of :payment_type

  after_create do
    self.create_payment
    self.cart.cart_items.each do |cart_item|
      if cart_item.product_variant
        cart_item.product_variant.countdown_inventory(cart_item.quantity)
      end
    end
  end

  def shipping_cost
    cart ? cart.shipping_cost : 0
  end

  def total_price
    unless @sum
      @sum = 0.00
      if self.cart
        for item in self.cart.cart_items
          @sum += item.price_including_tax
        end
      end
    end
    @sum
  end

  def new_customer_information_set(information)
    contact_information_sets.new(information.merge(information_type: 'customer'))
  end

  def new_delivery_information_set(information)
    contact_information_sets.new(information.merge(information_type: 'delivery'))
  end

  def customer_information_set
    contact_information_sets.where(information_type: 'customer').first
  end

  def delivery_information_set
    contact_information_sets.where(information_type: 'delivery').first ||
      customer_information_set
  end

  def delivery_information_exists?
    contact_information_sets.where(information_type: 'delivery').size == 1
  end

  def customer_full_name
    "#{customer_information_set.first_name} #{customer_information_set.last_name}"
  end
end
