# See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
class Ability
  include CanCan::Ability

  def initialize(user)

    if user.admin?
      can :manage, :all
    else

    can [:create, :edit, :update, :destroy], WebsiteMembership do |wm|
      wm.website.admins.include?(user)
    end

    end

  end
end
