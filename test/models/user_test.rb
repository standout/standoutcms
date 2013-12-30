require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'website membership should be destroyed when user is destroyed' do
    user = users(:crash_test_dummy)
    website = websites(:standout)
    WebsiteMembership.create do |w|
      w.user_id = user.id
      w.website_id = website.id
    end
    assert user.websites.include?(website)
    user.destroy
    assert !website.users.include?(user)
  end

  test 'new user email should contain link to standoutcms.se' do
    user = User.create! do |u|
      u.email = 'newuser@standout.se'
      u.password = 'secret'
      u.password_confirmation = 'secret'
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal [user.email], email.to
    assert_match(/standoutcms.se/, email.encoded)
  end

end