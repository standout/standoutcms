require "test_helper"

describe CreateMemberPasswordReset do
  let(:website) { websites :standout }
  let(:member) { create :member, website: website }
  subject { CreateMemberPasswordReset.call(member) }

  it "sets password_reset_token" do
    member.password_reset_token.must_be_nil
    subject
    member.password_reset_token.wont_be_nil
  end

  it "sets password_reset_sent_at" do
    member.password_reset_sent_at.must_be_nil
    subject
    member.password_reset_sent_at.wont_be_nil
  end

  it "must send an email" do
    subject
    assert_difference "ActionMailer::Base.deliveries.size", +1 do
      Delayed::Worker.new.work_off
    end
  end
end
