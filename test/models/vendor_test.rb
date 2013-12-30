require 'test_helper'

class VendorTest < ActiveSupport::TestCase

  def setup
    @vendor = Vendor.new
  end

  test 'slug should never be empty after creation' do
    @vendor.name = 'Apple'
    @vendor.website_id = websites(:standout).id
    assert @vendor.save
    assert @vendor.slug != ''
  end

  test 'logo should be saved' do
    @vendor.name = 'Apple'
    @vendor.website_id = websites(:standout).id
    @vendor.logo =  File.new("#{Rails.root}/test/fixtures/apple_logo.jpg")
    assert @vendor.save
    assert @vendor.logo?
    assert @vendor.logo_file_size.to_i > 0
    assert !@vendor.logo.url.match(/missing/)
    assert @vendor.logo.url.match(/apple/)
  end

  test 'should be in alphabetical order' do
    my_vendors = ["Xerox", "Samsung", "IBM", "Mionix"]
    my_vendors.each do |v|
      Vendor.create do |vendor|
        vendor.name = v
        vendor.website_id = websites(:standout).id
      end
    end
    ordered_vendors = websites(:standout).vendors
    assert_equal(ordered_vendors, ordered_vendors.sort_by(&:name))
  end

  test 'url pointer should be created along with vendor' do
    vendor = Vendor.new do |v|
      v.name = 'Samsung'
      v.website_id = websites(:standout).id
    end
    assert vendor.save
    assert_equal 1, vendor.url_pointers.size
  end

  test 'url pointers should be removed when changing slug' do
    vendor = Vendor.new do |v|
      v.name = 'Fortnox'
      v.website_id = websites(:standout).id
    end
    assert vendor.save
    assert_equal 1, vendor.url_pointers.size, "#{vendor.inspect}"
    vendor.slug = 'fortet'
    vendor.save!
    assert_equal 1, vendor.url_pointers.size
    assert vendor.url_pointers.first.path = "/vendors/fortet"
  end

  test 'url pointers should be destroyed with vendor' do
    ingo = Vendor.create do |v|
      v.name = "Ingo Maurer"
      v.website_id = websites(:standout).id
    end
    assert ingo.save
    assert_equal 1, ingo.url_pointers.size
    ingo.destroy
    assert_equal 0, ingo.url_pointers.size
  end

end