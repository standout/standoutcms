require 'test_helper'

class WebsiteMembershipTest < ActiveSupport::TestCase

  test 'it automatically creates a user if e-mail is not found' do
    assert_difference 'User.count' do
      WebsiteMembership.create(
        website_id: websites(:standout).id,
        email: 'somethingnew@example.org')
    end
  end

  test 'it connects to existing user if e-mail is in database' do
    assert_no_difference 'User.count' do
      WebsiteMembership.create(
        website_id: websites(:lenhovda).id,
        email: 'david@example.org'
      )
    end
  end

end