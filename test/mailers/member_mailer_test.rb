require "test_helper"

describe MemberMailer do
  let(:website) { websites :standout }
  let(:look) { looks :standout_look }
  let(:member) { create :member, website: website }

  describe "#approved" do
    let(:mail) { MemberMailer.approved(member, "password") }

    it "renders a warning when there is no such template" do
      mail.body.to_s.must_match(/need a template/)
    end

    describe "liquid template exists" do
      before { create :member_approved_email_page_template, look: look }

      it "renders the liquid template as body" do
        mail.body.to_s.must_equal("Hej #{member.email}")
      end
    end
  end
end
