class PagesController < ApplicationController

  # Try to find an asset by request path
  # this could be a Page, a Product, a CustomDataRow or something else.
  def show
    unless @website = current_website
      render404 and return
    end
    pointer = @website.url_pointers.where(:path => request.env["PATH_INFO"]).first
    if pointer && pointer.page
      render :text => render_the_template(@website, pointer.page.page_template, current_cart, { :page => pointer.page, :language => pointer.language })
    elsif pointer && pointer.product
      # TODO: why are we using another method to generate products?
      render :text => pointer.product.complete_html(current_member, @website.default_language, current_cart.id)
    elsif pointer && pointer.product_category
      render :text => render_the_template(@website, pointer.product_category.page_template, current_cart, { 'product_category'  => ProductCategoryDrop.new(pointer.product_category) })
    elsif pointer && pointer.custom_data_row
      render :text => render_the_template(@website, pointer.custom_data_row.custom_data_list.page.page_template, current_cart, { 'item' => CustomDataRowDrop.new(pointer.custom_data_row), :page => pointer.custom_data_row.page })
    elsif pointer && pointer.vendor
      render :text => render_the_template(@website, pointer.vendor.page_template, current_cart, { "vendor" => VendorDrop.new(pointer.vendor) })
    else
      # 404 - we got a missing page. Try to find a 404 template.
      template = @website.page_templates.where(:slug => '404').first
      if template
        render :text => render_the_template(@website, template, current_cart), :status => 404
      else
        render404
      end
    end
  rescue
    render404
  end

  def render404
        render :text => "
        <html><head><title>Not found</title><body>
        <h1>404: File not found</h1>
        <p>The requested path could not be found. Path: #{request.env["PATH_INFO"]}</p>
        <p>If you are the owner of this site, you can easily customize this message by adding a 
        template called '404' to your theme setting in Standout CMS.</p>
        </body>                                                                

                                                                                         </html>", :status => 404  
  end
end
