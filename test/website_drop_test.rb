require 'test_helper'
class WebsiteDropTest < ActiveSupport::TestCase

  test 'lists should be available through website drop' do
    website = websites(:standout)
    list = CustomDataList.create!(title: 'Test', liquid_name: 'test', website_id: website.id)
    wd = WebsiteDrop.new(website)
    assert_equal wd.lists["test"].id.to_s, list.id.to_s
  end

  test 'vendors should be available through website drop' do
    website = websites(:standout)
    Vendor.create do |v|
      v.website_id = website.id
      v.slug = 'test-vendor-available'
      v.name = 'Test'
    end
    assert_equal 1, website.reload.vendors.size

    wd = WebsiteDrop.new(website)
    assert_equal 1, wd.vendors.size
    assert_equal 'Test', wd.vendors.first.name
  end

  test 'drop should return latest timestamp on products' do
    website = websites(:standout)
    drop = WebsiteDrop.new(website)
    assert website.products.count > 0
    latest_product = website.products.order("updated_at desc").first
    assert_equal latest_product.updated_at.to_s,
    drop.latest_product.updated_at.to_s
  end

end
