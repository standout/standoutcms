require 'test_helper'

describe Members::SignupsController do
  let(:website) { websites :standout }
  let(:look) { looks :standout_look }
  before { request.host = "standout.standoutcms.dev" }

  describe "GET #new" do
    describe "as guest" do
      it "renders a warning about missing template" do
        get :new
        assert_response :success
        response.body.must_match(/need a template named member_signup/)
      end

      it "renders the member_signup template when existing" do
        create :member_signup_page_template, look: look
        get :new
        assert_response :success
        response.body.must_equal("<h1>Standout AB</h1>")
      end
    end
  end

  describe "POST #create" do
    describe "as guest" do
      it "creates member" do
        post :create, member: attributes_for(:member)
        assert_redirected_to root_url
        assigns(:member).full_name.must_equal("Glenn Glennsson")
      end

      it "creates member via json" do
        post :create, member: attributes_for(:member), format: :json
        assert_response :created
        json["member"]["full_name"].must_equal("Glenn Glennsson")
      end

      it "works with just email" do
        post :create, member: {
          email: "new.member@example.com"
        }
        assert_redirected_to root_url
      end

      it "redirects to specified path" do
        stupid_url = members_signin_url
        post :create, redirect_to: stupid_url, member: {
          email: "new.member@example.com"
        }
        assert_redirected_to stupid_url
      end
    end
  end
end
