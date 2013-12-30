require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  test 'order should be connected to website' do
    w = websites(:standout)
    o = Order.new(:website_id => w.id)
    assert o.website.id == w.id
  end

end
