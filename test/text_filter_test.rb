
require 'test_helper'

class TextFilterTest < ActiveSupport::TestCase

  test 'asset path should include look id' do
    page_template = page_templates(:pagetemplate_with_asset)
    html = Liquid::Template.parse(page_template.html.to_s).render({'page_template_id'  => page_template.id })
    doc = Nokogiri::HTML(html)
    assert_equal("/files/looks/#{page_template.look_id}/stylesheet.css", doc.css('#asset-path-test').first.content)
  end

  test 'money format should include money format given by website' do
    website = Website.new
    website.webshop_currency = 'SEK'
    website.money_format = '%n %u'
    website.money_separator = ','
    assert_equal(
      Liquid::Template.parse('{{ 100 | as_money}}').render(
        'website' => WebsiteDrop.new(website)
      ),
      '100,00 kr'
    )
  end

end
