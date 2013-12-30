module ProductsHelper
  
  def product_thumb(product)
    if product.product_images.any?
      image_tag(product.product_images.first.image.url(:small), :class => 'product-thumb')
    else
      image_tag('missing.png', :class => 'product-thumb')
    end
  end
  
end
