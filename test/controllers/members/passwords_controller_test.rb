require "test_helper"

describe Members::PasswordsController do
  let(:website) { websites :standout }
  let(:look) { looks :standout_look }
  before { request.host = "standout.standoutcms.dev" }

  describe "GET #new" do
    describe "as guest" do
      it "renders a warning about missing template" do
        get :new
        assert_response :success
        response.body.must_match(/a template named member_password_reset_new/)
      end

      it "renders the member_password_reset_new template when existing" do
        create(:member_password_reset_new_page_template, look: look)
        get :new
        assert_response :success
        response.body.must_match(/Fyll i din e-postadress här/)
      end
    end
  end

  describe "POST #create" do
    describe "as guest" do
      before { create :member_password_reset_email_page_template }
      before { create :member_password_reset_new_page_template }
      let(:member) { create :member, website: website }

      describe "when email is not found" do
        before { post :create, email: "notfound@example.com" }

        it "responds with success anyway" do
          assert_response :created
        end

        it "wont send email" do
          assert_no_difference "ActionMailer::Base.deliveries.size" do
            Delayed::Worker.new.work_off
          end
        end
      end

      it "must update token" do
        old_token = member.password_reset_token
        post :create, email: member.email
        assert_response :created
        Delayed::Worker.new.work_off
        assigns(:member).password_reset_token.wont_equal(old_token)
      end

      it "must update sent_at" do
        old_sent_at = member.password_reset_sent_at
        post :create, email: member.email
        assert_response :created
        Delayed::Worker.new.work_off
        assigns(:member).password_reset_sent_at.wont_equal(old_sent_at)
      end

      it "sends email with reset link" do
        post :create, email: member.email
        assert_response :created
        assert_difference "ActionMailer::Base.deliveries.size", +1 do
          Delayed::Worker.new.work_off
        end
      end
    end
  end

  describe "GET #edit" do
    describe "as guest" do
      let(:member) { create :member_with_password_token, website: website }

      it "redirects to new when token is invalid" do
        get :edit, id: member.id, token: "wrong token"
        assert_redirected_to members_passwords_new_url
      end

      it "redirects to new when id is wrong" do
        get :edit, id: 1234567890, token: member.password_reset_token
        assert_redirected_to members_passwords_new_url
      end

      it "renders a warning about missing template" do
        get :edit, id: member.id, token: member.password_reset_token
        assert_response :success
        response.body.must_match(/a template named member_password_reset_edit/)
      end

      it "renders the edit password page template when existing" do
        create(:member_password_reset_edit_page_template, look: look)
        get :edit, id: member.id, token: member.password_reset_token
        assert_response :success
        response.body.must_match(/Ange ditt nya lösenord här/)
      end
    end
  end

  describe "PATCH #update" do
    describe "as guest" do
      let(:member) { create :member_with_password_token, website: website }
      let(:token) { member.password_reset_token }
      let(:params) do
        { password: "password", password_confirmation: "password" }
      end

      it "uses password_reset_token to update password" do
        old_digest = member.password_digest
        post :update, id: member.id, token: token, member: params
        assert_redirected_to members_signin_url
        assigns(:member).password_digest.wont_equal(old_digest)
      end

      it "wont update when token is too old" do
        member.update_attribute(:password_reset_sent_at, 9.hours.ago)
        old_digest = member.password_digest
        post :update, id: member.id, token: token, member: params
        assert_redirected_to members_passwords_new_url
        assigns(:member).password_digest.must_equal(old_digest)
      end

      it "wont update when token is wrong" do
        old_digest = member.password_digest
        post :update, id: member.id, token: "iNvAlId", member: params
        assert_redirected_to members_passwords_new_url
        assigns(:member).password_digest.must_equal(old_digest)
      end

      it "wont update when confirmation does not match" do
        old_digest = member.password_digest
        p = params.merge(password_confirmation: "wrongword")
        post :update, id: member.id, token: token, member: p
        assert_response :unprocessable_entity
        assigns(:member).reload.password_digest.must_equal(old_digest)
      end
    end
  end
end
