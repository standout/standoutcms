class Notice < ActiveRecord::Base
  validates_presence_of :website_id, :user_id
  belongs_to :website
  belongs_to :user
  belongs_to :page

  after_create :remove_similar_notices

  # We don't want 20 notices about the same thing.
  def remove_similar_notices
    Notice.where(:website_id => self.website_id, :user_id => self.user_id, :message => self.message).where(["id != ? and created_at >= ?", self.id, self.created_at - 2.hours]).collect(&:destroy)
  end

end
