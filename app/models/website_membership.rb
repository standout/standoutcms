class WebsiteMembership < ActiveRecord::Base


  cattr_accessor :email
  belongs_to :website
  belongs_to :user
  has_many :allowed_pages

  attr_accessible :email, :website_id

  after_create :create_new_user

  def user
    super || User.new()
  end

  def email
    @email.nil? ? (user.nil? ? nil : user.email) : @email
  end

  def email=(email)
    @email = email
  end

  def can_edit?(page)
    return true if self.user.admin?
    return false unless self.user.websites.include?(page.website)
    if self.restricted_user?
      return !self.allowed_pages.find_by_page_id(page.id).nil?
    else
      return true
    end
  end

  def allowed_page_object_for(page)
    self.allowed_pages.find_by_page_id(page.id)    
  end

  private
  def create_new_user
        # Find or create a user by e-mail address
    u = User.where(email: self.email).first_or_initialize
    if u.new_record?
      random = User.random_pass
      u.password = random
    end
    u.save!
    self.update_attribute :user_id, u.id
  end

end
