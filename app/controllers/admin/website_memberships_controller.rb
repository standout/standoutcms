class Admin::WebsiteMembershipsController < ApplicationController

  def index
    @website_memberships = current_website.website_memberships
    render json: @website_memberships
  end

  # GET /website_memberships/1/edit
  def edit
    @website_membership = WebsiteMembership.find(params[:id])
    authorize! :edit, @website_membership
  end

  # POST /website_memberships
  # POST /website_memberships.xml
  def create
    @website_membership = WebsiteMembership.new(website_membership_params)
    @website_membership.website_id = current_website.id
    authorize! :create, @website_membership

    if @website_membership.save
      Notice.create(:website_id => @website_membership.website_id, :user_id => current_user.id, :message => "added #{@website_membership.email} to the editors")
      render json: @website_membership
    else
      render json: @website_membership, status: 422
    end
  end

  # PUT /website_memberships/1
  # PUT /website_memberships/1.xml
  def update
    @website_membership = WebsiteMembership.find(params[:id])
    authorize! :update, @website_membership

    respond_to do |format|
      if @website_membership.update(website_membership_params)
        format.html { redirect_to([:edit, :admin, @website_membership.website], :notice => 'WebsiteMembership was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @website_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @website_membership = WebsiteMembership.find(params[:id])
    authorize! :destroy, @website_membership
    @website_membership.destroy

    render json: @website_membership
  end

  private

  def website_membership_params
    params.require(:website_membership).permit %i(
      email
      user_id
      website_id
      website_admin
      restricted_user
    )
  end
end
