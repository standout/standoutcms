class PageDrop < Liquid::Drop

  def initialize(page, language = nil)
    @language = language ||= page.website.default_language
    @thepage = page
  rescue
    @thepage = Page.new
  end

  def id
    @thepage.id
  end

  def login_required
    @thepage.login_required
  end

  def password_hash
    @thepage.password_hash
  end

  def language
    @language
  end

  def languages
    @thepage.languages.collect(&:short_code)
  end

  # Return references to all pages the are translations of this page
  def translations
    @thepage.translations.collect{ |p| PageDrop.new(p, p.language) }
  end

  def title
    @thepage.title(@language)
  end

  def url
    @thepage.address(@language)
  end

  def complete_url
    @thepage.complete_address(@language)
  end

  def created_at
    @thepage.created_at
  end

  def updated_at
    @thepage.updated_at
  end

  def level
    @thepage.level
  end

  def children
    @thepage.children.collect{ |c| PageDrop.new(c, @language) }
  end

  def website
    WebsiteDrop.new(@thepage.website)
  end

  def show_in_menu
    @thepage.show_in_menu(@language)
  end

  def direct_link
    @thepage.direct_link(@language).to_s
  end

end
