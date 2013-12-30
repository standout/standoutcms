class Search
  def initialize(website)
    @website = website
  end
  
  def query(q)
    {
      :products => products(q)
    }
  end
  
  def products(q)
    q.blank? ? [] : @website.products.where("title like ?", "%#{q}%").all
  end
  
end