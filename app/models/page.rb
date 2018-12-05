class Page < ActiveRecord::Base

  attr_accessor :language, :password

  #acts_as_nested_set :scope => :website_id
  acts_as_tree :order => 'position asc', :scope => 'website_id'
  acts_as_list :scope => 'parent_id'
  default_scope { where ["deleted = ?", false] }

  belongs_to :website
  belongs_to :look
  belongs_to :page_template
  belongs_to :parent, :class_name => "Page", :foreign_key => "parent_id"

  has_many :content_items, -> { order "position asc" }
  has_many :translated_page_attributes
  has_many :url_pointers, :dependent => :destroy
  has_many :allowed_pages, :dependent => :destroy

  before_save :set_title, :check_root, :set_level
  #after_save :check_address
  after_save :create_url_pointer

	alias_method :original_page_template, :page_template
	serialize :translated_attributes_data

	def editors
	  self.website.website_memberships.collect{ |wm| wm if wm.can_edit?(self) }.compact
	end

	def create_url_pointer
	  self.url_pointers.destroy_all
	  self.languages.each do |language|
	    UrlPointer.create(:website_id => self.website_id, :page_id => self.id, :path => "/" + self.address(language.short_code), :language => language.short_code)
	  end
	end

  def page_template
    self.original_page_template || self.website.page_templates.where(:default_template => true).first || self.website.page_templates.first
  end


  # Always encrypt the page password
  def password=(pass)
    self.password_hash = Digest::SHA256.hexdigest(pass)
  end

  # Breadcrumbs generator, that can be used with liquid
  def breadcrumbs
    # Current page
    output = [[self.title, self.address, self.id]]
    # Unless we are dealing with the start_page
    unless self.position == 0
      # Add parents if any
      unless self.parent_id.blank?
        current_page = self
        self.level.times do
          if current_page.parent_id > 0
            page = Page.find(current_page.parent_id)
            output << [page.title, page.address, page.id] if page && page.position != 0
            current_page = page
          end
        end
      end
      # Add the root page
      page = self.website.pages.where(:position => 0).first
      output << [page.title, page.address, page.id] if page
    end
    output.reverse
  end

  def breadcrumbs_html
    output = ''
    self.breadcrumbs.each do |breadcrumb|
      selected = self.id == breadcrumb[2] ? "class='selected'" : "class='unselected'"
      output << "<a href='#{breadcrumb[1]}' #{selected} id='breadcrumb_#{breadcrumb[2]}'>#{breadcrumb[0]}</a>#{" &raquo; " if self.breadcrumbs.last != breadcrumb}"
    end
    output
  end

  # A page has many languages depending on what content items we have.
  def languages
    languages = [Language.where(["short_code = ?", self.website.default_language]).first]
    content_items.group('language').each do |ci|
      l = Language.where(["short_code = ?", ci.language]).first
      languages << l unless l.blank?
    end
    languages.uniq
  end

  # Return references to all translated versions of this page
  # as page objects with the proper language attached.
  def translations
    pages = []
    translated_attributes_data.keys.each do |key|
      p = self.class.find(id)
      p.language = key.to_s
      pages << p
    end
    pages
  end

  # Generate a working web page address from a string (without .html)
  def to_slug(string)
    #strip the string
    ret = string.strip

    ret.downcase!

    #blow away apostrophes
    ret.gsub!(/['`]/,"")

    # @ --> at, and & --> and
    ret.gsub!(/\s*@\s*/, " at ")
    ret.gsub!(/\s*&\s*/, " and ")

    ret.gsub!(/(å|ä)/, "a")
    ret.gsub!(/ö/, "o")


    #replace all non alphanumeric, underscore or periods with underscore
     ret.gsub!(/\s*[^A-Za-z0-9\.\-\/]\s*/, '_')

     #convert double underscores to single
     ret.gsub!(/_+/,"_")

     #strip off leading/trailing underscore
     ret.gsub!(/\A[_\.]+|[_\.]+\z/,"")


     ret
  end
  def default_address(language = 'sv')
    "#{language}/page_#{self.id}.html"
  end

  def content_items_with_language
    self.language = self.website.default_language if self.language.nil? || self.language.blank?
    self.content_items.where(language: self.language)
  end

  # Override delete method to avoid complete deletion, and keep
  # the regular destroy method.
  alias_method :regular_destroy, :destroy
  def destroy
    self.update_attribute :deleted, true
    self.children.each do |child|
      child.destroy
    end
    self
  end

  # TODO: Remove when we are sure this is not used anywhere
  def english_address
    self.address_translated('en')
  end

  def relative_english_address(page)
    tmp_address = "../"
    (page.address.split(/\//).size.to_i - 1).times do
      tmp_address << "../"
    end
    tmp_address << self.english_address.to_s
  end

  # If I am going to link to this page from (page), what relative path should I use?
  def relative_address(page, language = 'sv')
    "../" * page.number_of_slashes_in_path(language) << self.address_translated(language)
  end

  # How many slashes do we have in the path? Don't count the last char.
  def number_of_slashes_in_path(language)
    number_of_slashes = self.address_translated(language).mb_chars.last == "/" ? (self.address_translated(language).split(/\//).size.to_i) : (self.address_translated(language).split(/\//).size.to_i - 1)
  end

  def complete_address(language = 'sv')
    'http://' + (self.website.domain.to_s == "" ? self.website.subdomain.to_s + ".standoutcms.#{self.website.tld}" : self.website.domain.to_s) + '/' + self.address(language)
  end


  # See how deep we are in the levels, and store it for easy access.
  def set_level
    if self.parent
      t_level = 0
      p = self
      while p.parent != nil
        t_level += 1
        p = p.parent
      end
      self.level = t_level
    else
      self.level = 0
    end
    self.parent_id = 0 if self.parent_id.nil?
    true
  end

  def set_title
    if self.title(self.website.default_language).blank?
      self.title = default_title(self.website.default_language)
    end
  end

  def default_title(language = 'sv')
    language == 'sv' ? 'Namnlös sida' : 'Untitled'
  end

  # Title to be used in publishing mode.
  def publish_title(language = 'sv')
    self.seo_title.blank? ? (language == 'sv' ? self.title : self.english_title) : self.seo_title
  end

  # TODO: Look over this method.
  # Every page must have an address if we want it to work on the server.
  # if it is not set, give it a default
  def check_address
    self.languages.each do |language|
      if self.address(language.short_code).to_s == "" || self.address(language.short_code).to_s == self.default_address(language.short_code)

        if self.title(language.short_code).blank? || self.title(language.short_code) == self.default_title(language.short_code)
          # Do nothing?
        else
          push_translation(language.short_code, 'address', self.to_slug(self.title_translated(language.short_code)) << ".html")
        end
      end
    end
  end

  # Returns the template as one big chunk with the partials included
  def complete_liquid_template
    html = self.page_template.html.to_s
    html.gsub(/\{%\sinclude\s['|"](\w{1,60})['|"]\s%\}/) {|match| self.page_template.look.page_templates.where(slug: $1).first.html }
  end

  # Caching website liquid is a must since it can be really slow
  # if queried multiple times.
  def website_liquid
    @website_liquid ||= self.website.to_liquid
  end

  def website_liquid=(liquid)
    @website_liquid = liquid
  end

  def complete_html(current_member, language = 'sv', extra_stuff = {}, keep_liquid = false)
    stuff = {
      'cart'              => CartDrop.new(extra_stuff.delete(:cart)),
			'page'							=> PageDrop.new(self, language),
      'language'					=> language,
      'posts' 						=> self.website.posts,
      'categories'				=> self.website.blog_categories,
      'breadcrumbs'				=> self.breadcrumbs,
      'page_template_id'	=> self.page_template_id,
      'current_member' => current_member ? MemberDrop.new(current_member) : nil,
      'website'           => WebsiteDrop.new(self.website) }

    self.website.custom_data_lists.each do |custom_data|
      stuff["#{custom_data.liquid_name}"] = custom_data
    end

    # We might have som extra stuff we want to render (from blogposts etc)
    extra_stuff.each do |es|
      stuff["#{es.first}"] = es.last
    end

    if keep_liquid
      doc = Hpricot(self.complete_liquid_template)
    else
      doc = Hpricot(Liquid::Template.parse(self.page_template.html.to_s).render(stuff))
    end

    # Our extra javascripts and CSS files
    begin
      doc.at("head").inner_html = "\n<meta name='description' content='#{self.description(language)}' />\n" << doc.at("head").inner_html
    rescue
      logger.info "Warning: could not find head/title-tag. Might be because of liquid inclusion though."
    end
    # Content items
    doc.search(".editable").each do |element|
      out = ""
      for item in self.content_items.where(for_html_id: "#{element.attributes['id']}").where(page_id: self.id).where(language: language)
        if keep_liquid
          out << item.text_content.to_s
        else
          out << item.produce_output
        end
      end
      begin
        element.inner_html = out
      rescue => e
        logger.info "#{e.inspect}"
      end
    end

    # Menu items
    doc.search(".menu").each do |menu|
      menu_item = Menu.where(page_template_id: page_template_id, for_html_id: menu.attributes['id']).first_or_create
      menu_item.start_level = menu.attributes['data-startlevel'] if menu.attributes['data-startlevel'] != ""
      menu_item.levels = menu.attributes['data-sublevels'] if menu.attributes['data-sublevels'] != ""
      menu.inner_html = menu_item.html(self, language)
    end

    # Breadcrumb items
    doc.search(".breadcrumbs").each do |breadcrumb|
      breadcrumb.inner_html = self.breadcrumbs_html
    end

    # Layout images
    doc.search(".cms-layoutimage").each do |li|
      out = ""
      for item in self.content_items.where(for_html_id: "#{li.attributes['id']}").where(page_id: self.id).where(language: language)
        out << item.produce_output
      end
      li.inner_html = out
    end

    doc.to_original_html
  rescue => e
     logger.info "#{e.inspect}"
     logger.info e.backtrace.join("\n")
    "<html><body><h2>Page Generation Error</h2><p>#{CGI.escape(e.inspect)}</p></body></html>"
  end

  # helper method for knowing if page should be marked in menu
  def marked?(current_page)
    self.id == current_page.id || current_page.child_of?(self)
  end

  def menuhtml(page, language, menu, number_of_levels = 0, selected_page = nil)

    out = ""

    # Should this be selected?
    #selected = selected_page.id == self.id || self.ancestors.include?(selected_page) || selected_page.child_of?(self)
    selected_class = self.marked?(selected_page) ? 'selected' : 'unselected'

    if self.show_in_menu(language) == true

      if self.direct_link(language).blank?
        out = "<li class='#{selected_class} #{self.parent_id? ? 'subpage' : 'root'}'><a href=\"#{self.complete_address(language)}\" id=\"menuitem_#{self.id}\" class='#{selected_class} #{self.parent_id? ? 'subpage' : 'root'}' title=\"#{self.title(language)}\">#{self.title(language)}</a>"
      else
        out = "<li class='#{selected_class} #{self.parent_id? ? 'subpage' : 'root'}'  id=\"direct_link_#{self.id}\"><a href=\"#{self.direct_link(language)}\" id=\"menuitem_#{self.id}\" class='#{selected_class} #{self.parent_id? ? 'subpage' : 'root'}' title=\"#{self.title(language)}\">#{self.title(language)}</a>"
      end

      # Output for children
      if self.children.length > 0 && number_of_levels < menu.levels
        number_of_levels += 1
        out << "<ul id=\"page_#{self.id}_children\" class=\"page_children\">"
        for child in self.children
          out << child.menuhtml(child, language, menu, number_of_levels, selected_page)
        end
        out << "</ul>"
        number_of_levels -= 1
      end
      out << "</li>"
    else
      ""
    end
  end

  # TODO: Remove this? Is it used somewhere else?
  def generate_menuhtml(selected_page = nil, language = 'sv', menu_item = nil, number_of_levels = 0)

    if self.show_in_menu(language) == true

      out = "<li #{selected}><a href=\"#{self.complete_address(language)}\" id=\"menuitem_#{self.id}\" #{selected} title=\"#{self.title(language)}\">#{self.title(language)}</a>"

      if self.children.length > 0 && number_of_levels < menu_item.levels
        number_of_levels += 1
        out << "<ul id=\"page_#{self.id}_children\" class=\"page_children\">"
        for child in self.children.find(:all, :order => "position asc")
          out << child.generate_menuhtml(selected_page, language, menu_item, number_of_levels)
        end
        number_of_levels -= 1
        out << "</ul>"
      end
      out << "</li>"
    else
      "#{number_of_levels} >= #{menu_item.levels}"
    end
  rescue => e
    logger.info "GENERATE MENUHTML FAILED: #{e.inspect}"
    "<!-- menuhtml -->"
  end

  # Make sure we are having a parent!
  def check_root
    ids = []
    if self.parent
      node = self.parent
      while node != nil
        node = node.parent
        if node && (node.id == self.id || ids.include?(node.id))
          node.children.first.update_attribute :parent_id, nil
          break
        end
        ids << node.id if node
      end
    end
  end

  def all_children_ids
    all_children.map(&:id)
  end

  def available_parents
    if new_record?
      self.class.where(website_id: self.website_id).order(:lft)
    else
      self.class.where(website_id: self.website_id).where.not(id: [id].concat(all_children_ids)).order(:lft)
    end
  end

  def child_of?(page)
    all_parent_ids.include? page.id.to_i
  end

  # returns array with this pages´ parent_ids
  def all_parent_ids
    parent_ids = []
    parent = self.parent
    while parent do
      parent_ids << parent.id.to_i
      if !parent.parent_id.nil? && parent.parent_id > 0
        parent = parent.parent
      else
        parent = false
      end
    end
    parent_ids
  end

  def title(language = nil)
    language = self.website.default_language if language.nil?
    self.translated_attributes('title', language)
  end

  def description(language = nil)
    language = self.website.default_language if language.nil?
    self.translated_attributes('description', language)
  end

  def address(language = nil)
    language = self.website.default_language if language.nil?
    a = self.translated_attributes('address', language)
    a.blank? ? self.default_address(language) : a
  end

  def direct_link(language=nil)
    language = self.website.default_language if language.nil?
    a = self.translated_attributes('direct_link', language)
    a.blank? ? self[:direct_link] : a
  end

  def show_in_menu(language=nil)
    language = self.website.default_language if language.nil?
    a = self.translated_attributes('show_in_menu', language)
    a.nil? ? true : a
  end

  def show_in_menu?
    a = self.translated_attributes('show_in_menu', self.website.default_language)
    a.nil? ? true : a
  end

  def translated_attributes_data
    self[:translated_attributes_data] ||= {}
  end

  def translated_attributes(field, language)
    language ||= self.website.default_language
    self.translated_attributes_data["#{language}"]["#{field}"] rescue nil
  end

  def store_translated_attributes(field, value, language = nil)
    language = self.website.default_language if language.nil?
    unless self.translated_attributes_data.has_key?(language.to_s)
      self[:translated_attributes_data][language.to_s] = {}
    end
    if field.to_s == 'show_in_menu'
      value = value.to_s.match(/(true|t|yes|y|1)$/i) != nil
    end
    self[:translated_attributes_data][language.to_s][field.to_s] = value
  end

  def title=(t)
    store_attribute('title', t)
  end

  def address=(t)
    store_attribute('address', t)
  end

  def description=(t)
    store_attribute('description', t)
  end

  def direct_link=(t)
    store_attribute('direct_link', t)
  end

  def show_in_menu=(t)
    store_attribute('show_in_menu', t)
  end

  private
  def store_attribute(attribute_name, translation)
    if translation.is_a?(String)
      store_translated_attributes(attribute_name.to_s, translation)
    elsif translation.is_a?(TrueClass) || translation.is_a?(FalseClass)
      store_translated_attributes(attribute_name.to_s, translation)
    else
      translation.each_pair do |language, value|
        store_translated_attributes(attribute_name.to_s, value, language)
      end
    end
  end

end
