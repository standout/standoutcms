require "test_helper"

describe UpdateMember do
  let(:website) { websites :standout }

  describe "when approved is changed to true" do
    let(:member) { create :member, website: website }

    it "must send delayed approval email" do
      assert_no_difference "ActionMailer::Base.deliveries.count" do
        UpdateMember.call(member, approved: true)
      end

      assert_difference "ActionMailer::Base.deliveries.count", +1 do
        Delayed::Worker.new.work_off
      end
    end

    it "wont send another email" do
      member.update!(approved: true, password: "password",
                     password_confirmation: "password")
      assert_no_difference "ActionMailer::Base.deliveries.count" do
        UpdateMember.call(member, approved: true)
        Delayed::Worker.new.work_off
      end
    end
  end
end
