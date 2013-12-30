class SearchDrop < Liquid::Drop
  
  def initialize(website, query)
    @search = Search.new(website)
    @query = query.to_s
  end
  
  def products
    @search.products(@query).collect{ |p| ProductDrop.new(p) }
  end
  
end