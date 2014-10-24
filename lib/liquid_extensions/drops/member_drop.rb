class MemberDrop < Liquid::Drop
  delegate :id, :approved, :email, :username, :first_name, :last_name,
    :postal_street, :postal_zip, :postal_city, :phone, :full_name,
    :full_address, to: :member

  attr_accessor :password

  def initialize(member, password = nil)
    @member = member
    @password = password
  end

  def errors
    @errors ||= ErrorDrop.new(@member.errors)
  end

  private

  attr_reader :member
end
