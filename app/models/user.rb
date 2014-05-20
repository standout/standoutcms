class User < ActiveRecord::Base
  include Gravtastic

  gravtastic :default => 'identicon', :size => '30'

  attr_accessor :password
  has_many :websites, :through => :website_memberships
  has_many :website_memberships, :dependent => :destroy
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, :message => "doesn't look like a real e-mail address"
  before_save :prepare_password
  after_create :send_password
  validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true

  LOCALES = ['sv', 'en']

  # Return 'sv' as default locale.
  def locale
    (self[:locale].to_s != '' && User::LOCALES.include?(self[:locale])) ? self[:locale].to_s : 'sv'
  end

  def self.authenticate(email, password)
    user = User.first(:conditions => { :email => email })
    if user.blank? || BCrypt::Engine.hash_secret(password, user.password_salt) != user.password_hash
      user = nil
    end
    user
  rescue
    nil
  end

  # Can this user edit a specific page?
  def can_edit?(page)
    page.editors.collect(&:user).compact.include?(self)
  end

  def admin_for(website)
    self.admin? || website.admins.include?(self)
  end

  def send_password
    Notifier.signup(self).deliver
  end

  def password_reset_code
    Digest::SHA256.hexdigest(self.id.to_s + self.updated_at.to_s)[4..12]
  end

  # Returns a pronouncable random password consisting
  # of both letters and digits.
  def self.random_pass
    new_password = ""
    consonants = "bcdfghjklmnprstv"
    vowels = "aeiou"
    2.times do
      new_password << consonants[rand(consonants.size-1)]
      new_password << vowels[rand(vowels.size-1)]
    end
    new_password << (rand(89)+10).to_s
    new_password
  end

  private

  def set_password

  end
  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

end
