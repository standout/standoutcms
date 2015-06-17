require "test_helper"

describe MemberSession, "#update" do
  let(:website) { websites :standout }
  let(:member) { create :member, website: website }
  let(:session) do
    {}
  end

  it "updates session" do
    MemberSession.update(session, member).must_equal(member)
    session[:member_id].must_equal(member.id)
    session[:member_website_id].must_equal(member.website_id)
    session[:member_expire_at].must_be :>, Time.zone.now
  end
end

describe MemberSession, "#destroy" do
  let(:website) { websites :standout }
  let(:member) { create :member, website: website }
  let(:session) do
    {
      member_id: member.id,
      member_website_id: website.id,
      member_expire_at: 24.hours.from_now
    }
  end

  it "returns member" do
    MemberSession.destroy(session).must_be_nil
    session[:member_id].must_be_nil
    session[:member_website_id].must_be_nil
  end
end

describe MemberSession, "#get" do
  let(:website) { websites :standout }
  let(:member) { create :member, website: website }
  let(:session) do
    {
      member_id: member.id,
      member_website_id: website.id,
      member_expire_at: 24.hours.from_now
    }
  end

  it "returns member" do
    MemberSession.get(session, website).must_equal(member)
  end

  it "must return nil when website has changed" do
    website = websites(:lenhovda)
    MemberSession.get(session, website).must_be_nil
  end
end
