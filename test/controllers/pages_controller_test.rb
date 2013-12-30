require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  def setup
    request.host = "standout.standoutcms.dev"
    @controller = Admin::PagesController.new
    session[:user_id] = users(:david).id
  end

  test 'should save show in menu' do
    page = pages(:standout_secondpage)
    page.store_translated_attributes('show_in_menu', false, 'sv')
    assert page.show_in_menu('sv') == false

    post :update, :id => page.id, :page => { :show_in_menu => { :sv => 1 }}

    updated_page = Page.find(page.id)

    assert updated_page.show_in_menu('sv') == true

  end

  test 'should render 404 if website is not found on pages controller' do
    @controller = PagesController.new
    request.host = 'blaha.standoutcms.dev'
    get :show
    assert :missing
  end

  test 'should render with the correct language on page' do
    @controller = PagesController.new
    page = pages(:standout_secondpage)
    page.store_translated_attributes('title', 'English', 'en')
    page.store_translated_attributes('url', 'english-page', 'en')
    page.save!

    request.env["PATH_INFO"] = ["english-page"]
    get :show
    assert :success

  end

  test 'should not be able to save page order on other websites' do
    login_as(:hacker)
    post :order
    assert_response :redirect
  end

  test 'should be able to save page order on my website' do
    login_as(:david)
    post :order
    assert_response :success
  end

  test 'should be able to save page order on other sites if i am admin' do
    login_as(:admin_without_site)
    post :order
    assert_response :success
  end

  test 'should get a 404 error for missing pages' do
    @controller = PagesController.new

    request.env["PATH_INFO"] = ["missing-page"]
    get :show
    assert_response :missing

    # Internet Explorer needs at least 512 bytes unless you want it to
    # fail completely. Strange ... but hey, we're used to it.
    assert response.body.to_s.bytes.to_a.size >= 512
  end

  test 'should get a 404 error template if that is defined for the website' do
    @controller = PagesController.new
    look = websites(:standout).looks.first

    # Add a page template
    template = PageTemplate.create do |pt|
      pt.look_id = look.id
      pt.slug = '404'
      pt.name = '404'
      pt.html = '<div class="missing">Missing content goes here.</div>'
    end

    # Make the request
    request.env["PATH_INFO"] = ["missing-page"]
    get :show
    assert_response :missing
    assert_select "div.missing"
  end

  test 'should be able to show index page with subpages' do
    get :index
    assert_response :success
  end

end
