class Menu < ActiveRecord::Base
  before_create :set_default_values

  def set_default_values
    self.start_level = 0
  end

  # Generates complete HTML for all menu items corresponding to this menu
  # for a specific page
  def html(thepage, language = 'sv')

    pages = []

    # Find all pages
    if self.start_level == 0
      pages = thepage.website.root_pages
    else
      tmppages = Page.where(website_id: thepage.website_id).where(level: self.start_level)

      # Walk through all pages and see if the page we are visiting is included in the tree
      for page in tmppages
        if page.self_and_siblings.include?(thepage) || page.children.include?(thepage) || page.ancestors.include?(thepage) || thepage.child_of?(page)
          pages = page.self_and_siblings
          break
        end
      end

    end

    # HTML
    if pages.empty?
      out = "<!-- no pages for menu found: page_id: #{thepage.id}, language: #{language} menu_id: #{self.id} -->"
    else
      out = "<ul class=\"menu\" id=\"cmsmenu-#{self.id}\">"
      for page in pages
        out << page.menuhtml(thepage, language, self, 0, thepage)
      end
      out << "</ul>"
    end
  end

end
