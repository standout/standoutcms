class Language < ActiveRecord::Base
  validates_uniqueness_of :name, :short_code
  validates_presence_of :name, :short_code
end
