require 'test_helper'

class NotifierTest < ActiveSupport::TestCase
  test '#order_placed should have no default recipient' do
    notifier = Notifier.order_placed(
      websites(:standout),
      customers(:one),
      orders(:one)
    )
    assert_nil notifier[:to]
  end

  test "#order_placed should set locale to the website's default" do
    notifier = Notifier.order_placed(
      websites(:standout),
      customers(:one),
      orders(:one)
    )
    assert_equal I18n.locale.to_s, websites(:standout).default_language.to_s
  end

  test '#order_payed should have no default recipient' do
    notifier = Notifier.order_payed(orders(:one))
    assert_nil notifier[:to]
  end

  test "#order_payed should set locale to the website's default" do
    notifier = Notifier.order_payed(orders(:one))
    assert_equal I18n.locale.to_s, websites(:standout).default_language.to_s
  end

  test "placed orders should have variant information" do
    email = Notifier.order_placed(websites(:standout), customers(:one), orders(:one))
    email[:to] = 'shopowner@example.com'
    assert email.deliver
    assert_match "Variant: #{product_variants(:one).description}",  email.encoded, "#{email.encoded}"
  end
end
