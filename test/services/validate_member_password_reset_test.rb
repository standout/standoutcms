require "test_helper"

describe ValidateMemberPasswordReset, "#call" do
  let(:website) { websites :standout }
  let(:member) { create :member_with_password_token, website: website }
  let(:validator) { ValidateMemberPasswordReset.new(member) }

  describe "correct token" do
    it "returns true" do
      assert validator.call(member.password_reset_token)
    end
  end

  describe "expired token" do
    it "returns false" do
      member.update_attribute(:password_reset_sent_at, 9.hours.ago)
      refute validator.call(member.password_reset_token)
    end
  end

  describe "wrong token" do
    it "returns false" do
      refute validator.call("invalidToken")
    end
  end

  describe "member has no token" do
    it "returns false" do
      member.update_attribute(:password_reset_token, nil)
      refute validator.call(member.password_reset_token)
    end
  end

  describe "token has never been sent" do
    it "returns false" do
      member.update_attribute(:password_reset_sent_at, nil)
      refute validator.call(member.password_reset_token)
    end
  end
end
