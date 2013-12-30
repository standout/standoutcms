class UrlPointer < ActiveRecord::Base

  attr_accessible :path, :website_id, :page_id, :language, :custom_data_row_id,
                  :post_id, :product_id, :product_category_id, :vendor_id


  belongs_to :page
  belongs_to :custom_data_row
  belongs_to :product
  belongs_to :product_category
  belongs_to :vendor

  def complete_html
    if self.page
      self.page.complete_html(self.language)
    elsif self.custom_data_row
      self.custom_data_row.complete_html
    else
      self.destroy
      "<!-- error in generation, probably old url pointer -->"
    end
  end

end
