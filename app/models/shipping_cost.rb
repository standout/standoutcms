class ShippingCost < ActiveRecord::Base
  belongs_to :website

  # If the value is within the range it returns the cost, otherwise it returns
  # nil.
  def calculate_cost(value)
    from = from_value.to_f
    return cost if not to_value and value >= from_value
    return cost if value >= from and value < to_value
  end
end
