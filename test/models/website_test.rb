require 'test_helper'

class WebsiteTest < ActiveSupport::TestCase

  def setup
    @website = Website.new
  end

  test 'should_not_be_able_to_create_website_without_subdomain' do
    assert !@website.valid?
    assert !@website.errors[:subdomain].empty?
  end

  test 'should have an api key and default settings after creation' do
    @website.title = 'New website'
    @website.subdomain = 'new-website'
    assert @website.save
    assert @website.api_key.size == 16
    assert @website.webshop_currency == 'SEK'
    assert @website.webshop_live == '0'
    assert @website.money_format == '%n %u'
    assert @website.money_separator == ','
  end

  test 'should pick the matching shipping costs' do
    website = websites(:standout)
    assert_equal website.get_matching_shipping_costs(0),    [45]
    assert_equal website.get_matching_shipping_costs(299),  [45]
    assert_equal website.get_matching_shipping_costs(300),  [95]
    assert_equal website.get_matching_shipping_costs(2999), [95]
    assert_equal website.get_matching_shipping_costs(3000), [0]
  end

  test 'should be able to find via domain alias' do
    website = websites(:standout)
    website.domainaliases = "standoutsolutions.com,standout.dk"
    website.save
    assert_equal Website.find_by_domainaliases("standout.dk").id, website.id
    assert_equal Website.find_by_domainaliases("standoutsolutions.com").id, website.id
  end

end
