class Member < ActiveRecord::Base
  has_secure_password validations: false
  include HasSecurePasswordWhenApproved

  belongs_to :website

  validates :email,    uniqueness: { scope: :website_id }
  validates :username, uniqueness: { scope: :website_id }, allow_nil: true
  validates :website, presence: true

  before_validation :disallow_blank_username

  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def full_address
    [postal_street, "#{postal_zip} #{postal_city}"].compact.join(", ")
  end

  private

  def disallow_blank_username
    self.username = nil if self.username.blank?
  end

  def generate_password
    password_digest.present? and return
    # Generate a friendly string randomly to be used as password
    self.password = SecureRandom.base64(4).tr('+/=lIO0', 'pqrsxyz')
    self.password_confirmation = password
    password
  end
end
