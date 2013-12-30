class ContactInformationSet < ActiveRecord::Base
  belongs_to :order

  validates :first_name,    presence: true
  validates :last_name,     presence: true
  validates :address_line1, presence: true
  validates :zipcode,       presence: true
  validates :city,          presence: true

  # TODO: move to controller
  attr_accessible :first_name, :last_name, :address_line1, :zipcode, :city, :information_type

  def attrs
    Hash[*attributes.map{ |k, v| [k.to_sym, v] }.flatten]
  end
end
