class Domain < ActiveRecord::Base
  belongs_to :website
  validates_uniqueness_of :name
end
