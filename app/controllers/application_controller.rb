require "application_responder"

#render Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html


  include ControllerAuthentication
  include UrlHelper

  helper :all # include all helpers, all the time
  helper_method :current_user, :is_admin?, :current_website_id, :current_website, :current_cart, :current_member

  before_filter :set_locale
  after_filter :set_website
  after_filter :set_csrf_cookie_for_ng

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8d3b55fa38b9b12ecc889fab9fcdec25'

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def check_login
    # If we have a user, check that he is allowed to edit this website
    if current_user
      if current_website
        redirect_to login_path unless current_user.admin? || current_website.users.include?(current_user)
      end
    else
      # User can log in with an API key instead.
      # Check for apikey and log in the user
      if params[:apikey]
        website = Website.find(params[:website_id])
        if params[:apikey] == website.api_key
          session[:website_id] = website.id
          session[:user_id] = website.admins.first.id if website.admins.first
          return true
        else
          render :text => "Login failed", :status => 500 and return false
        end
      else
        redirect_to login_path
      end
    end
  end

  # Try to set the locale, first base it on the current user locale
  # and secondly on the preferred locale from the browser.
  def set_locale
    if current_user
      I18n.locale = current_user.locale if User::LOCALES.include?(current_user.locale.to_s)
    else
      preferred_locales = request.headers['HTTP_ACCEPT_LANGUAGE'].split(',').map { |l| l.split(';').first } rescue []
      I18n.locale = preferred_locales.select { |l| User::LOCALES.include?(l.to_s) }.first
    end
  end

  def admin_only
    unless is_admin?
      redirect_to '/'
    end
  end

  def set_website
    true
  end

  # Used when images are not found on our server.
  def image_rescue
    send_data File.read("#{Rails.root}/app/assets/images/not_found.png"), :filename => 'not_found.png', :type => "image/png", :disposition => "inline"
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end


  protected

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def current_website_id
    current_website.id
  end

  def current_website
    @website ||= (
      Website.find_by_subdomain(request.subdomain.to_s) ||
      Website.find_by_domain(request.host.to_s) ||
      Website.find_by_domainaliases(request.host.to_s)
    )
  end

  def current_user
    if session[:user_id]
      @me ||= User.find(session[:user_id])
    else
      false
    end
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
    false
  end

  def current_member
    @current_member ||= MemberSession.get(session, current_website)
  end

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create(:website_id => current_website.id)
    session[:cart_id] = cart.id
    cart
  end

  def is_admin?
    current_user && current_user.admin?
  end

#  def handle_unverified_request
#    logger.warn "Unverified request detected. Resetting session."
#    super # call the default behaviour which resets the session
#  end

  # TODO: move into /lib
  def render_the_template(website, page_template, cart, extra_stuff = {})

    if page_template.nil?
      return "No matching page template found."
    end

    keep_liquid = false
    page = extra_stuff.delete(:page)
    language = extra_stuff.delete(:language)
    language = website.default_language if language.blank?
    query = extra_stuff.delete(:query)
    logger.debug "Query: #{query}"
    unless query.blank?
      extra_stuff.merge!({ 'search_result' => SearchDrop.new(website, query), 'query' => query })
    end

    stuff = {
      'cart'              => CartDrop.new(cart.id),
      'language'          => language,
      'page'              => PageDrop.new(page, language),
      'page_template_id'  => page_template.id,
      'website'           => WebsiteDrop.new(website),
      'current_member'    => current_member ? MemberDrop.new(current_member) : nil,
      'flash'             => { 'alert' => flash[:alert], 'notice' => flash[:notice] },
      'params'            => params,
      "form_authenticity_token" => form_authenticity_token
    }.merge(extra_stuff)

    logger.debug "Stuff: #{stuff.inspect}"

    # Parse the liquid
    doc = Hpricot(Liquid::Template.parse(page_template.html.to_s).render(stuff))

    # Our extra javascripts and CSS files
    begin
      doc.at("head").inner_html = "\n<meta name='description' content='#{page.description(language)}' />\n" << doc.at("head").inner_html
    rescue
      logger.info "Warning: could not find head/title-tag. Might be because of liquid inclusion though."
    end



    # Menu items
    doc.search(".menu").each do |menu|
      menu_item = Menu.find_or_create_by(page_template_id: page_template.id, for_html_id: menu.attributes['id'])
      menu_item.start_level = menu.attributes['data-startlevel'] if menu.attributes['data-startlevel'] != ""
      menu_item.levels = menu.attributes['data-sublevels'] if menu.attributes['data-sublevels'] != ""
      if page
        menu.inner_html = menu_item.html(page, language)
      else
        menu.inner_html = menu_item.html(website.root_pages.first)
      end
    end

    # Breadcrumb items
    unless page.blank?

      # Content items
      doc.search(".editable").each do |element|
        out = ""
        for item in page.content_items.where(for_html_id: "#{element.attributes['id']}").where(page_id: page.id).where(language: language)
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

      doc.search(".breadcrumbs").each do |breadcrumb|
        breadcrumb.inner_html = page.breadcrumbs_html
      end

      # Layout images
      doc.search(".cms-layoutimage").each do |li|
        out = ""
        for item in page.content_items.where(for_html_id: "#{li.attributes['id']}").where(page_id: page.id).where(language: language)
          out << item.produce_output
        end
        li.inner_html = out
      end
    end

    doc.to_original_html

  end

  def render_slug(slug, options = {})
    if template = current_website.page_templates.find_by(slug: slug)
      render_the_template(current_website, template, current_cart, options)
    else
      "You need a template named #{slug} to render this page"
    end
  end

  def pagination_meta_for(collection)
    {
      current_page: collection.current_page,
      next_page:    collection.next_page,
      prev_page:    collection.previous_page,
      total_pages:  collection.total_pages,
      total_count:  collection.total_entries
    }
  end
end
