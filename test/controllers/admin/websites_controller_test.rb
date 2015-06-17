require "test_helper"

# old tests can be found in controllers/websites_controller_test.rb

describe Admin::WebsitesController do
  let(:website) { websites :standout }
  before { request.host = "standout.standoutcms.dev" }

  describe "PATCH #update" do
    describe "as admin" do
      before { login_as :david }

      it "must update member_signup_enabled to false" do
        website.update(member_signup_enabled: "1")
        patch :update, id: website.id, website: {
          member_signup_enabled: "0"
        }
        assert_redirected_to edit_admin_website_url(website)
        assigns(:website).member_signup_enabled.must_equal("0")
      end

      it "must update member_signup_enabled to true" do
        website.update(member_signup_enabled: false)
        patch :update, id: website.id, website: {
          member_signup_enabled: "1"
        }
        assert_redirected_to edit_admin_website_url(website)
        assigns(:website).member_signup_enabled.must_equal("1")
      end
    end
  end
end
