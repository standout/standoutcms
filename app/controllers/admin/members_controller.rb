class Admin::MembersController < ApplicationController
  before_action :check_login
  before_action :find_member, only: %w(edit update destroy)
  respond_to :json, :html
  responders :collection

  def index
    @members = current_website.members.load
    respond_with :admin, @members
  end

  def edit
    respond_with :admin, @member
  end

  def update
    @member.update(permitted_params)
    respond_with :admin, @member
  end

  def destroy
    @member.destroy
    respond_with :admin, @member
  end

  private

  def find_member
    @member = current_website.members.find(params[:id])
  end

  def permitted_params
    params.require(:member).permit %i(email username approved first_name
    last_name phone postal_street postal_zip postal_city)
  end
end