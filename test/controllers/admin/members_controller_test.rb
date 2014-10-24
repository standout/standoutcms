require "test_helper"

describe Admin::MembersController do
  let(:website) { websites :standout }
  before { request.host = "standout.standoutcms.dev" }

  describe "GET #index" do
    describe "as admin" do
      before { login_as(:david) }

      it "must get index" do
        get :index
        assert_response :success
      end
    end
  end

  describe "GET #edit" do
    let(:member) { create :member, website: website }

    describe "as admin" do
      before { login_as(:david) }

      it "must get edit" do
        get :edit, id: member.id
        assert_response :success
      end
    end
  end

  describe "PATCH #update" do
    let(:member) { create :member, website: website }

    describe "as admin" do
      before { login_as(:david) }

      it "must update" do
        patch :update, id: member.id, member: { first_name: "Glenn" }
        assert_redirected_to admin_members_path
      end

      it "sends email when changing to approved: true" do
        member.approved.must_equal(false);
        patch :update, id: member.id, member: { approved: true }
        assert_difference "ActionMailer::Base.deliveries.count", +1 do
          Delayed::Worker.new.work_off
        end
        assigns(:member).approved.must_equal(true);
      end

      it "wont send another email when updating again" do
        member.update!(approved: true, password: "password",
                      password_confirmation: "password")
        patch :update, id: member.id, member: { approved: true }
        assert_no_difference "ActionMailer::Base.deliveries.count", +1 do
          Delayed::Worker.new.work_off
        end
      end
    end

    describe "as member" do
      it "wont update" do
        patch :update, id: member.id, member: {
          first_name: "Glenn"
        }
        assert_redirected_to login_path
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:member) { create :member, website: website }

    describe "as admin" do
      before { login_as(:david) }

      it "must get edit" do
        assert_difference "Member.count", -1 do
          delete :destroy, id: member.id
        end
        assert_redirected_to admin_members_path
      end
    end
  end
end
