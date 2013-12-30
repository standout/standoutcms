class Extra < ActiveRecord::Base
  belongs_to :content_item
  has_many :extra_views

  attr_accessible :display_url
end
