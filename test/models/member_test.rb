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

describe Member, "#username" do
  let(:website) { websites(:standout) }

  it "allows many with nil value" do
    create(:member, username: nil, website: website)
    create(:member, username: nil, website: website)
  end
end
