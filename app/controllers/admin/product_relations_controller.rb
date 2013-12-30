class Admin::ProductRelationsController < ApplicationController
  
  before_filter :check_login
  before_filter :load_website_and_product
  
  def load_website_and_product
    if current_user.admin?
      @website = current_website
    else
      @website = current_user.websites.find(current_website.id)
    end    
    @product = @website.products.find(params[:product_id])
  end

  # We are actually creating two relations here, one from the product to the related product, 
  # and one back from the related product to this product. 
  # This is probably the typical use case: connect two products together and both should be related.
  def create
    @related_product = @website.products.find(params[:product_relation][:related_product_id])

    @related_product.product_relations.build(:related_product_id => @product.id)
    @related_product.save

    @product.product_relations.build(:related_product_id => @related_product.id)
    @product.save
    redirect_to :back  
  rescue
    redirect_to :back
  end
  
  def destroy
    relation = @product.product_relations.find(params[:id])
    relation.destroy
    redirect_to :back
  end
  
end