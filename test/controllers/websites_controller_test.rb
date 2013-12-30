# -*- encoding : utf-8 -*-
require 'test_helper'

class WebsitesControllerTest < ActionController::TestCase

  def setup
    @controller = WebsitesController.new
  end

  test 'should display front page' do
    request.host = "standout.standoutcms.dev"
    website = websites(:standout)
    get :show
    assert_response :success
  end

  test 'should generate a descriptive error that the page is not found' do
    request.host = "not-found.standoutcms.dev"
    get :show
    assert_response :not_found
  end

  test 'should display front page via domain alias' do
    website = websites(:standout)
    request.host = 'testing.host'
    get :show
    assert_response :not_found

    website.update_attribute(:domainaliases, 'testing.host')
    get :show
    assert_response :success
  end

  test 'should display front page via IDN domain alias' do
    request.host = 'xn--vxtforum-0za.se'
    website = websites(:standout)

    get :show
    assert_response :not_found

    website.update_attribute(:domainaliases, 'testing.host,xn--vxtforum-0za.se')
    get :show
    assert_response :success
  end

  test 'routing based on domains should work' do
    standout = websites(:standout)
    standout.update_attribute(:domainaliases, 'xn--vxtforum-0za.se,www.xn--vxtforum-0za.se')
    assert_routing 'http://standoutcms.dev/',             { :controller => 'websites', :action => 'index' }
    assert_routing 'http://www.standoutcms.dev/',         { :controller => 'websites', :action => 'index' }
    assert_routing 'http://standout.standoutcms.dev/',    { :controller => 'websites', :action => 'show' }
    assert_routing 'http://standout.standoutcms.dev/login',{ :controller => 'sessions', :action => 'new' }
    assert_routing 'http://standout.se/',                 { :controller => 'websites', :action => 'show' }
    assert_routing 'http://not-found.standoutcms.dev/',   { :controller => 'websites', :action => 'show' }
    assert_routing 'http://standout.standoutcms.dev/abc', { :controller => 'pages', :action => 'show', :path => 'abc' }
    assert_routing 'http://xn--vxtforum-0za.se/',         { :controller => 'websites', :action => 'show' }
    assert_routing 'http://www.xn--vxtforum-0za.se/',     { :controller => 'websites', :action => 'show' }
    assert_routing 'http://www.xn--vxtforum-0za.se/abc',  { :controller => 'pages', :action => 'show', :path => 'abc' }
  end

end