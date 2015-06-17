class Members::SessionsController < ApplicationController
  respond_to :html, :json

  def new
    render text: render_slug("member_signin")
  end

  def create
    if valid_login?
      MemberSession.update(session, @member)

      respond_with @member do |format|
        format.html { redirect_to (params[:redirect_to] || root_path) }
      end
    else
      @member = Member.new
      @member.valid?

      respond_with @member do |format|
        format.json { head :unauthorized }
        format.html do
          render text: render_slug("member_signin"), status: :unauthorized
        end
      end
    end
  end

  def show
    render json: current_member
  end

  def destroy
    MemberSession.destroy(session)
    respond_to do |format|
      format.json { head :no_content }
      format.html { redirect_to (params[:redirect_to] || root_url) }
    end
  end

  private

  def find_member
    params[:login].present? and params[:password].present? or return nil
    t = Member.arel_table
    email_or_username = t[:email].eq(params[:login].downcase)
      .or(t[:username].eq(params[:login]))
    @member = current_website.members.find_by(email_or_username)
  end

  def valid_login?
    find_member && @member.approved? && @member.authenticate(params[:password])
  end
end
