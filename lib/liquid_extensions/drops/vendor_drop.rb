class VendorDrop < Liquid::Drop
  
  def initialize(vendor)
    @vendor = vendor
  end

  def url
    @vendor.complete_url
  end
  
  def logo
    @vendor.logo.url(:small)
  end
  
  def name
    @vendor.name
  end
  
  def id
    @vendor.id
  end
  
  def products
    @vendor.products.collect{ |p| ProductDrop.new(p) }
  end

end