class DibsPayment
  attr_reader :values

  FakeCartItem = Struct.new(:quantity, :title, :product_id, :price_including_tax)

  def initialize(order, overrides)
    @order    = order
    @customer = order.customer
    @website  = order.website
    @cart     = order.cart
    overrides[:test] = "1" unless @website.webshop_live
    @values = default_params.merge(overrides)
  end

  def hmac
    @dibs = ::DIBS::HMAC.calculate(@values, @website.dibs_hmac_key)
  end

  def entrypoint
    "https://sat1.dibspayment.com/dibspaymentwindow/entrypoint"
  end

  private

  def default_params
    HashWithIndifferentAccess.new({
      amount: ((@cart.total_price_including_tax + @cart.shipping_cost) * 100).to_i,
      currency:           @website.webshop_currency,
      merchant:           @website.dibs_merchant_id,
      orderId:            @order.id.to_s,
      billingAddress:     @customer.address_line1,
      billingAddress2:    @customer.address_line2,
      billingEmail:       @customer.email,
      billingFirstName:   @customer.first_name,
      billingLastName:    @customer.last_name,
      billingMobile:      @customer.phone.to_s,
      billingPostalCode:  @customer.zipcode.to_s,
      billingPostalPlace: @customer.city,
      oiTypes:            "QUANTITY;UNITCODE;DESCRIPTION;ITEMID;AMOUNT;VATPERCENT",
      oiRow1: oi_row(FakeCartItem.new(1, "Shipping cost", "shipping_cost", @cart.shipping_cost)),
    }).tap do |hash|
      @cart.cart_items.each_with_index do |cart_item, index|
        hash["oiRow#{index + 2}"] = oi_row(cart_item)
      end
    end
  end

  def oi_row(cart_item)
    # QUANTITY;UNITCODE;DESCRIPTION;ITEMID;AMOUNT;VATPERCENT
    [
      cart_item.quantity,
      "pcs",
      cart_item.title,
      cart_item.product_id,
      (cart_item.price_including_tax * 100).to_i,
      0, # We are already including VAT
    ].join(";")
  end
end
