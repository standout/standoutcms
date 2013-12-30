class VendorsDrop < Liquid::Drop
  def initialize(website)
    @website = website
  end
  
  def to_liquid
    @website.vendors.collect{ |v| VendorDrop.new(v) }
  end
end