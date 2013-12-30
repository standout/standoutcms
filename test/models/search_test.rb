require 'test_helper'

class SearchTest < ActiveSupport::TestCase

  test 'should find product by title' do
    product = products(:testproduct)
    search = Search.new(product.website)
    result = search.query(product.title)
    assert result[:products].include?(product)
  end

  test 'should not find product with other search word' do
    product = products(:testproduct)
    search = Search.new(product.website)
    result = search.query("other")
    assert !result[:products].include?(product)
  end

  test 'empty search should return no results' do
    search = Search.new(websites(:standout))
    result = search.query("")
    assert result[:products].empty?
  end

  test 'search drop products should work' do
    s = SearchDrop.new(websites(:standout), "book")
    assert s.products.first.is_a?(ProductDrop)
    assert_equal products(:one).id, s.products.first.id
  end

end
