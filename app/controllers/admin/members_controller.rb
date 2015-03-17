class Admin::MembersController < ApplicationController
  before_action :check_login
  before_action :find_member, only: %w(edit update destroy)
  before_action :load_website, only: %w(index)
  respond_to :json, :html
  responders :collection

  def index
    @members = Search.new(@website).members(search_params).
      order(get_order_param).paginate(
      page: params[:page],
      per_page: params[:per_page] || 50)

    respond_with :admin, @members, meta: pagination_meta_for(@members)
  end

  def edit
    respond_with :admin, @member
  end

  def update
    UpdateMember.call(@member, permitted_params)
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

  def load_website
    if current_user.admin?
      @website = current_website
    else
      @website = current_user.websites.find(current_website.id)
    end
  end

  def search_params
    p = params.permit(%i(email username approved name phone postal)).
      reject { |_key, val| val.blank? }
    p[:approved] = booleanify(p[:approved]) if p[:approved]
    p
  end

  def booleanify(val)
    case val
    when "1" then true
    when "0" then false
    else nil
    end
  end

  def get_order_param
    order = params[:order] == "desc" ? "DESC" : "ASC"
    case params[:order_by]
    when "email"    then "email #{order}"
    when "username" then "username #{order}"
    when "approved" then "approved #{order}"
    when "name"
      "first_name #{order}, last_name #{order}"
    when "phone" then "phone #{order}"
    when "postal"
      "postal_street #{order}, postal_zip #{order}, postal_city #{order}"
    end
  end
end
