class ContactInformationSet < ActiveRecord::Base
  belongs_to :order

  validates :first_name,    presence: true
  validates :last_name,     presence: true
  validates :address_line1, presence: true
  validates :zipcode,       presence: true
  validates :city,          presence: true

  def attrs
    Hash[*attributes.map{ |k, v| [k.to_sym, v] }.flatten]
  end
end
