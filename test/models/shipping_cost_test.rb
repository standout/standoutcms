require 'test_helper'

class ShippingCostTest < ActiveSupport::TestCase
  def setup
    @shipping_cost = shipping_costs(:one)
  end

  test 'should return cost if value matches' do
    assert_equal @shipping_cost.calculate_cost(100), 45
  end

  test 'should return nil if values does not match' do
    assert_equal @shipping_cost.calculate_cost(500), nil
  end
end
