require 'test_helper'

describe Member do
  let(:website) { websites(:standout) }
  let(:attrs) do
    {
      email: "member123@example.com", website: website,
      password: "password", password_confirmation: "password"
    }
  end

  it "is valid attrs" do
    member = Member.new(attrs)
    assert member.valid?, member.errors.to_yaml
  end

  it "wont be valid without website_id" do
    member = Member.new(attrs)
    member.website_id = nil
    assert member.invalid?, member.errors.to_yaml
  end

  it "wont allow multiple members with same email on a website" do
    Member.create!(attrs)
    member = Member.new(attrs)
    assert member.invalid?, member.errors.to_yaml
  end
end

describe Member, "#password" do
  let(:website) { websites :standout }

  # This behaviour is achieved via HasSecurePasswordWhenApproved concern

  describe "approved is false" do
    let(:member) { build :member, approved: false, website: website }

    it "allows nil password_digest" do
      member.password_digest.must_be_nil
      assert member.valid?, member.errors.to_yaml
    end
  end

  describe "approved is true" do
    let(:member) { build :member, approved: true, website: website }

    it "wont allow nil password_digest" do
      member.password_digest.must_be_nil
      assert member.invalid?, member.errors.to_yaml
    end

    it "wont be valid without confirmed password" do
      member.password = "password"
      member.password_confirmation.must_be_nil
      assert member.invalid?
    end

    it "works when password is confirmed" do
      member.password = "password"
      member.password_confirmation = "password"
      assert member.valid?, member.errors.to_yaml
    end
  end
end

describe Member, "#username" do
  let(:website) { websites(:standout) }

  it "allows many with nil value" do
    create(:member, username: nil, website: website)
    create(:member, username: nil, website: website)
  end

  it "replaces blank username with nil" do
    create(:member, username: "", website: website)
    create(:member, username: "", website: website)
  end
end
