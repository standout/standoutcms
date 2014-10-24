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

  # Convenience method for signing in as a member factory
  # Usage:
  #   before { signin :member }
  # or:
  #   let(:member) { create :member }
  #   before { signin member }
  def signin(member, options = {})
    options[:website] ||= websites(:standout)
    if member.is_a?(Symbol)
      member = FactoryGirl.create(member, options)
    end
    MemberSession.update(session, member)
    member
  end

  # immediately imvoked let, just like in rspec
  def self.let!(symbol, &block)
    let(symbol, &block)
    before { send(symbol) }
  end

  def json
    JSON.parse(response.body)
  end
end
