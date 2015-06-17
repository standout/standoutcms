class Members::SignupsController < ApplicationController
  before_filter :check_signups_enabled

  respond_to :html, :json

  def new
    render text: render_slug("member_signup")
  end

  def create
    @member = current_website.members.new(permitted_params)
    @member.save

    respond_with @member, location: nil do |format|
      format.html do
        if @member.persisted?
          redirect_to (params[:redirect_to] || root_url)
        else
          render status: 422, text: render_slug("member_signup", {
            "member" => MemberDrop.new(@member)
          })
        end
      end
    end
  end

  private

  def permitted_params
    params.require(:member).permit %i(email username approved first_name
    last_name phone postal_street postal_zip postal_city)
  end

  def check_signups_enabled
    unless current_website.member_signup_enabled?
      flash[:alert] = t("flash.members.signups.new.alert")
      respond_to do |format|
        format.json { head :forbidden }
        format.html { redirect_to root_url }
      end
    end
  end
end
