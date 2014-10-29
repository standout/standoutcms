class WebsitesController < ApplicationController

  before_filter :check_login
  before_filter :load_websites

  skip_before_filter :check_login, :only => [:show]


  # GET /websites/1
  # GET /websites/1.xml
  def show
    @website = current_website
    if @website.nil?
      render :text => "No website configured at this address.", :status => :not_found
    else
      @page = @website.root_pages.first
      render :text => render_the_template(@website, @page.page_template, current_cart, { :page => @page })
    end
  end

  # GET /websites/new
  # GET /websites/new.xml
  def new
    @new_website = Website.new
    respond_to do |format|
      format.html { render :layout => 'application' }# new.html.erb
      format.xml  { render :xml => @website }
    end
  end

  # GET /websites/1/edit
  def edit
    @website = current_website
    @website_membership = WebsiteMembership.new(:user_id => current_user.id, :website_id => @website.id)
    redirect_to root_url unless @websites.include?(@website)
  end

  # POST /websites
  # POST /websites.xml
  def create
    @website = Website.new(website_params)
    @website.users << current_user
    respond_to do |format|
      if CreateWebsite.call(@website)
        Notice.create(:website_id => @website.id, :user_id => current_user.id, :message => 'created website')
        format.html { redirect_to root_url, :notice => t('website_created') }
        format.xml  { render :xml => @website, :status => :created, :location => @website }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @website.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /websites/1
  # PUT /websites/1.xml
  def update
    if current_user.admin?
      @website = Website.find(params[:id])
    else
      @website = current_user.websites.find(params[:id])
    end

    respond_to do |format|
      if @website.update(website_params)
        Notice.create(:website_id => @website.id, :user_id => current_user.id, :message => 'updated website settings')

        flash[:notice] = 'Website was successfully updated.'
        format.html { redirect_to(@website) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @website.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /websites/1
  # DELETE /websites/1.xml
  def destroy
    @website = @websites.find(params[:id])
    @website.destroy
    Notice.create(:website_id => @website.id, :user_id => current_user.id, :message => 'deleted website')

    respond_to do |format|
      format.html { redirect_to(websites_url) }
      format.xml  { head :ok }
    end
  end

  def support
    @website = Website.find(params[:id])
  end

  protected
  def load_websites
    if current_user && current_user.admin?
      @websites = Website.all(:order => 'title asc')
    elsif current_user
      @websites = current_user.websites.uniq
    end
  end

  private

  def website_params
    params.require(:website).permit %i(
      domain
      subdomain
      domainaliases
      title
      email
      default_language
      blog_page_id
      blog_category_page_id
      paypal_business_email
      dibs_merchant_id
      dibs_hmac_key
      webshop_live
      webshop_currency
      website_money_format
      website_money_separator
      website_webshop_live
      order_confirmation_title
      order_confirmation_header
      order_confirmation_footer
      payment_confirmation_title
      payment_confirmation_header
      payment_confirmation_footer
      member_signup_enabled
    )
  end

end
