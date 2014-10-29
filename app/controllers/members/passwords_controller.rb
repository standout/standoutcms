class Members::PasswordsController < ApplicationController
  respond_to :html, :json

  before_action :find_member_by_id, only: [:edit, :update]
  before_action :check_token, only: [:edit, :update]

  def new
    render text: render_slug("member_password_reset_new")
  end

  def create
    if params[:email].present? && params[:email] =~ Member::EMAIL_REGEXP
      @member = current_website.members.find_by(email: params[:email])

      @member && CreateMemberPasswordReset.call(@member)
      status = :created
      flash.now[:notice] = I18n.t("flash.members.passwords.create.notice",
                              email: params[:email])
    else
      status = :unprocessable_entity
      flash.now[:alert] = I18n.t("flash.members.passwords.create.alert")
    end
    respond_to do |format|
      format.html do
        render status: status, text: render_slug("member_password_reset_new")
      end
      format.json { head status }
    end
  end

  def edit
    render text: render_slug("member_password_reset_edit", {
      "id" => params[:id],
      "token" => params[:token]
    })
  end

  def update
    saved = UpdateMember.call(@member, password_reset_params)
    respond_with @member do |format|
      format.html do
        if saved
          redirect_to members_signin_url
        else
          render status: 422, text: render_slug("member_password_reset_edit", {
            "id" => params[:id],
            "token" => params[:token],
            "member" => MemberDrop.new(@member)
          })
        end
      end
    end
  end

  private

  def find_member_by_id
    @member = current_website.members.find_by(id: params[:id])
  end

  def check_token
    unless @member && ValidateMemberPasswordReset.call(@member, params[:token])
      flash.now[:alert] = t("flash.members.passwords.edit.alert")
      respond_to do |format|
        format.html { redirect_to members_passwords_new_url }
        format.json { head :bad_request }
      end
    end
  end

  def password_reset_params
    params.require(:member).permit(:password, :password_confirmation)
      .merge(password_reset_token: nil)
  end
end
