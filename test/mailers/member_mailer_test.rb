require "test_helper"

describe MemberMailer do
  let(:website) { websites :standout }
  let(:look) { looks :standout_look }

  describe "#approved" do
    let(:member) { create :member, website: website }
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

  describe "#password_reset_link" do
    let(:member) { create :member_with_password_token, website: website }
    let(:mail) { MemberMailer.password_reset_link(member) }

    it "renders a warning when there is no such template" do
      mail.body.to_s.must_match(/need a template/)
    end

    describe "liquid template exists" do
      before { create :member_password_reset_email_page_template, look: look }

      it "renders the liquid template as body" do
        mail.body.to_s.must_match(member.password_reset_token)
      end
    end
  end
end
