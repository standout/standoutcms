class Customer < ActiveRecord::Base
  has_many   :orders, :dependent => :destroy
  belongs_to :website

  validates :email, presence: true, format: { with: /@/ }

  def contact_information
    order = orders.last
    return {} unless order
    information = order.customer_information_set.attrs || {}
    information.merge(email: email)
  end

  def first_name
    contact_information[:first_name]
  end

  def last_name
    contact_information[:last_name]
  end

  def address_line1
    contact_information[:address_line1]
  end

  def address_line2
    contact_information[:address_line1]
  end

  def zipcode
    contact_information[:zipcode]
  end

  def city
    contact_information[:city]
  end

  def phone
    contact_information[:phone]
  end

  def company_name
    contact_information[:company_name]
  end

  def vat_identification_number
    contact_information[:vat_identification_number]
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
