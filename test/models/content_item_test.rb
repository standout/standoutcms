require 'test_helper'

class ContentItemTest < ActiveSupport::TestCase

  test 'output from remote items should grab the contents of the page' do
    extra = Extra.create!(display_url:'http://example.org/')
    ci = ContentItem.create!(content_type:'remote', page_id: Page.first.id, extra_id: extra.id)
    assert ci.produce_output.match('Example Domain'), "#{ci.produce_output}"
  end

end