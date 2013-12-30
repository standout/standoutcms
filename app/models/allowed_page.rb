class AllowedPage < ActiveRecord::Base
  belongs_to :user
  belongs_to :website_membership
  belongs_to :page
  after_validation :connect_to_user, :on => :create
  
  validates_presence_of :page_id
  validates_presence_of :website_membership_id
  validates_uniqueness_of :website_membership_id, :scope => :page_id
  
  def connect_to_user
    self.user_id = self.website_membership.user_id
  end
  
end
