require "test_helper"

describe Importers::MemberImporter do
  let(:website) { websites :standout }
  let(:important_json) do
    [
      {
        "username" => "karlpetter",
        "email"    => "karlpetter@example.com",
        "name"     => "Karl-Petter Karlsson Pettersson",
        "address"  => "GÃ¶kÃ¤rtstigen 123",
        "zipcode"  => "12345",
        "city"     => "Example City",
        "phone"    => "123-456789"
      }
    ]
  end

  let(:importer) { Importers::MemberImporter.new(website, important_json) }

  it "reads json_array from file" do
    importer.json_array.must_be_kind_of(Array)
    importer.json_array.length.wont_equal(0)
  end

  describe "#fix_encoding" do
    let(:swede) { importer.json_array.detect { |m| m["address"] =~ /Ã¶/ } }

    describe "incorrect encoding" do
      it "converts to utf-8" do
        swede["address"].must_match(/Ã¶/)
        importer.fix_encoding
        swede["address"].wont_match(/Ã¶/)
      end
    end
  end

  describe "#member_from_json" do

    it "returns a member model with attrs set" do
      swede = importer.json_array.detect { |m| m["address"] =~ /Ã¶/ }
      importer.fix_encoding
      member = importer.member_from_json(swede)
      assert_equal website,                  member.website
      assert_equal "Karl-Petter",            member.first_name
      assert_equal "Karlsson Pettersson",    member.last_name
      assert_equal "karlpetter",             member.username
      assert_equal "karlpetter@example.com", member.email
      assert_equal "Gökärtstigen 123",       member.postal_street
      assert_equal "12345",                  member.postal_zip
      assert_equal "Example City",           member.postal_city
      assert_equal "123-456789",             member.phone
    end
  end

  describe "member_from_json works for all records" do
    before { importer.fix_encoding }

    it "all records are valid" do
      members = importer.json_array.map do |json|
        importer.member_from_json(json)
      end

      members.wont_be :empty?

      members.each do |member|
        assert member.valid?, member.errors.to_yaml
      end
    end
  end
end
