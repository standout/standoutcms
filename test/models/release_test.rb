require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase

  test 'should display changed pages' do
    p = pages(:standout_frontpage)
    p.update_attribute(:title, "New title")
    r = Release.new
    r.website_id = websites(:standout).id
    assert r.changed_pages.include?(p)
  end
  
  test 'last release date should equal website creation date if no releases has been made' do
    website = websites(:website_without_releases)
    r = Release.new
    r.website_id = website.id
    assert_equal r.last_released_at, website.created_at
  end
  
  test 'release without website should not break' do
    r = Release.new
    assert r.last_released_at.is_a?(Time)
  end
  
  test 'user should be able to publish certain pages' do
    r = Release.new
    r.website_id = websites(:standout).id
    
    # update all pages
    websites(:standout).pages.each do |page|
      page.update_attribute :title, "New updated title"
    end
    
    r.publish_pages = [pages(:standout_secondpage)]
    assert r.save
    
    assert_equal pages(:standout_secondpage).published_at, r.reload.created_at
    assert_not_equal pages(:standout_frontpage).published_at, r.reload.created_at

  end
  
end
