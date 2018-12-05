class PageTemplate < ActiveRecord::Base

  versioned

  scope :no_partials, -> { where(partial: false) }
  belongs_to :look

  has_many :pages
  after_save :touch_pages

  def touch_pages
    self.pages.collect(&:touch)
  end

  def file_name
    self.partial? ? "_#{self.slug}.liquid" : "#{self.slug}.liquid"
  end

  def used?
    pages.length > 0
  end

  def website
    self.look.website
  end

  def delete_version?
    true
  end

  def create_destroyed_version
    #
  end
end
