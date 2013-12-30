class Release < ActiveRecord::Base

  attr_accessor :publish_pages
  
  belongs_to :website
  belongs_to :user
  
  after_create :update_marked_pages
  
  def changed_pages
    self.website.pages.where("updated_at > ?", last_released_at)
  end
  
  # Returns the last time when the website was published/released.
  def last_released_at
    if self.website
      self.website.releases.empty? ? self.website.created_at : self.website.releases.first
    else
      Time.now
    end
  end
  
  def update_marked_pages
    self.publish_pages.to_a.each do |page|
      page.update_attribute :published_at, self.created_at
    end
  end
  
end
