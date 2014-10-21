require 'rubygems'
require 'mocha/setup'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
include ActionDispatch::TestProcess

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
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

  # immediately imvoked let, just like in rspec
  def self.let!(symbol, &block)
    let(symbol, &block)
    before { send(symbol) }
  end
end
