require 'test_helper'

describe Members::SessionsController do
  let(:website) { websites :standout }
  before { request.host = "standout.standoutcms.dev" }

  describe "GET #new" do
    describe "as guest" do
      it "renders a warning about missing template" do
        get :new
        assert_response :success
      end
    end
  end

  describe "POST #create" do
    before { create :member_signin_page_template }
    let!(:member) { create :approved_member, website: website }

    describe "as guest" do
      it "works with email" do
        session[:member_id].must_be_nil
        post :create, login: member.email, password: "password"
        assert_redirected_to root_url
        session[:member_id].wont_be_nil
      end

      it "works with username" do
        session[:member_id].must_be_nil
        post :create, login: member.email, password: "password"
        assert_redirected_to root_url
        session[:member_id].wont_be_nil
      end

      it "redirects to custom path" do
        session[:member_id].must_be_nil
        post :create, login: member.email, password: "password",
          redirect_to: members_signin_url
        assert_redirected_to members_signin_url
        session[:member_id].wont_be_nil
      end

      it "wont trigger server error when params are missing" do
        post :create
        assert_response :unauthorized
      end

      it "wont signin when password is wrong" do
        session[:member_id].must_be_nil
        post :create, login: member.email, password: "WrongPassword"
        assert_response :unauthorized
        session[:member_id].must_be_nil
      end
    end
  end

  describe "GET #show" do
    describe "as member" do
      let!(:member) { signin :member }

      it "renders current member as json" do
        get :show
        json["member"]["id"].must_equal(member.id)
      end
    end
  end

  describe "DELETE #destroy" do
    describe "as member" do
      before { signin :member }

      it "must signout" do
        delete :destroy
        assert_redirected_to root_path
        session[:member_id].must_be_nil
      end

      it "must redirect_to specified path after signout" do
        delete :destroy, redirect_to: members_signin_url
        assert_redirected_to members_signin_url
        session[:member_id].must_be_nil
      end
    end

    describe "as guest" do
      it "wont get server error" do
        delete :destroy
        assert_redirected_to root_url
        session[:member_id].must_be_nil
      end
    end
  end
end
