require 'test_helper'

describe Search, :products do
  it 'should find product by title' do
    product = products(:testproduct)
    search = Search.new(product.website)
    result = search.query(product.title)
    assert result[:products].include?(product)
  end

  it 'should not find product with other search word' do
    product = products(:testproduct)
    search = Search.new(product.website)
    result = search.query("other")
    assert !result[:products].include?(product)
  end

  it 'empty search should return no results' do
    search = Search.new(websites(:standout))
    result = search.query("")
    assert result[:products].empty?
  end

  it 'search drop products should work' do
    s = SearchDrop.new(websites(:standout), "book")
    assert s.products.first.is_a?(ProductDrop)
    assert_equal products(:one).id, s.products.first.id
  end
end

describe Search, :members do
  let(:website) { websites(:standout) }
  let!(:member) { create :member, website: website }

  def search(params)
    Search.new(website).members(params)
  end

  it "matches nothing when no such email is found" do
    search(email: "glenn@example.com").must_be :empty?
  end

  it "can search for parts" do
    search(email: member.email[1..-2]).must_include(member)
    search(username: "glenn"[1..-2]).must_include(member)
    search(name: "Glenn Glennsson"[1..-2]).must_include(member)
    search(phone: "012-345 67 89"[1..-2]).must_include(member)
    search(postal: "Västergatan 6, 35230 Växjö"[1..-2]).must_include(member)
  end

  it "handles boolean search" do
    search(approved: false).must_include(member)
    search(approved: nil).must_include(member)
  end
end
