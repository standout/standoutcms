require 'rubygems'
#uncomment the following line to use spork with the debugger



ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
 include ActionDispatch::TestProcess
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Convenience method for loggin in as a user
  def login_as(username)
    session[:user_id] = users(username.to_sym).id
  end
end
