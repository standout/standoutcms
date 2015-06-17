class Importers::MemberImporter
  attr_accessor :json_array, :website, :members

  def initialize(website, array_or_string)
    case array_or_string
    when String
      @json_array = JSON.parse(File.read(Rails.root.join(array_or_string)))
    when Array
      @json_array = array_or_string
    else
      fail "invalid argument, give an array or a filename"
    end

    @members = []

    @website = website
  end

  def fix_encoding
    json_array.map! do |json|
      fix_encoding_of(json, "name")
      fix_encoding_of(json, "address")
      fix_encoding_of(json, "city")
      json
    end
    self
  end

  def create_members
    json_array.each do |json|
      create_member(member_from_json(json))
    end
    self
  end

  def create_member(member)
    if member.save
      @members << member
    else
      puts member.errors.to_yaml
    end
  end

  def member_from_json(json)
    name = json["name"].split
    Member.new do |m|
      m.website = website
      m.first_name = name.first
      m.last_name  = name[1..-1].join(" ")
      m.username      = json["username"]
      m.email         = json["email"]
      m.postal_street = json["address"]
      m.postal_zip    = json["zipcode"]
      m.postal_city   = json["city"]
      m.phone         = json["phone"]
    end
  end

  private

  def fix_encoding_of(model, attr)
    model[attr] = model[attr].encode("iso-8859-1").force_encoding("utf-8")
  rescue Encoding::UndefinedConversionError
  end
end
