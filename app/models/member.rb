class Member < ActiveRecord::Base
  has_secure_password

  belongs_to :website

  validates :email,    uniqueness: { scope: :website_id }
  validates :username, uniqueness: { scope: :website_id }, allow_nil: true
  validates :website, presence: true
end
