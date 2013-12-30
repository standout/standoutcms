require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  def setup
    @controller = SearchController.new
  end
  
  test 'search result page should give ok status' do
    request.host = "standout.standoutcms.dev"
    get :index, { :q => 'test' }
    assert_response :success
  end
  
  test 'search result page should give not_implemented status if no search page template is present' do
    request.host = "website-without-search-template.standoutcms.dev"
    get :index, { :q => 'test' }
    assert_response :not_implemented
  end
  
  test 'search result page should be able to print the query and results' do
    request.host = "standout.standoutcms.dev"
    get :index, { :q => 'test' }
    assert_select 'title', 'Search'
    assert_select '#query', 'test'
    assert_select '#results' do
      assert_select "li.product-result"
    end
    assert_select "#product_#{products(:testproduct).id}", products(:testproduct).title
  end
  
end