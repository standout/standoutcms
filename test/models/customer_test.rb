require 'test_helper'

class CustomerTest < ActiveSupport::TestCase

  test 'customer should be connected to website' do
    w = websites(:standout)
    c = Customer.new(website_id: w.id, email: 'david@standout.se')
    assert c.website.id == w.id
  end

  test "customers should have a full name" do
    w = websites(:standout)
    c = Customer.new(website_id: w.id, email: 'david@standout.se')
    c.stubs(:first_name).returns('David')
    c.stubs(:last_name).returns('Svensson')
    assert 'David Svensson' == c.full_name
  end

end
