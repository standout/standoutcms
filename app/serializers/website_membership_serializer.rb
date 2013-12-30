class WebsiteMembershipSerializer < ActiveModel::Serializer
  attributes :id, :email, :website_admin, :restricted_user, :editable

  def editable
    current_user.admin? || current_user.admin_for(object.website)
  end
end
