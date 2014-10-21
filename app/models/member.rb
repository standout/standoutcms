class Member < ActiveRecord::Base
  has_secure_password

  belongs_to :website

  validates :email,    uniqueness: { scope: :website_id }
  validates :username, uniqueness: { scope: :website_id }, allow_nil: true
  validates :website, presence: true

  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def full_address
    [postal_street, "#{postal_zip} #{postal_city}"].compact.join(", ")
  end
end
