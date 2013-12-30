require 'test_helper'
class PageDropTest < ActiveSupport::TestCase
  
  test 'translated page drop should give correct title' do
    page = pages(:standout_frontpage)
    page.store_translated_attributes(:title, 'English', 'en')
    drop = PageDrop.new(page, 'en')
    assert_equal 'English', drop.title
  end

  test 'hidden pages' do
    page = pages(:standout_frontpage)
    page.show_in_menu = true
    page.save
    drop = PageDrop.new(page)
    assert drop.show_in_menu
    page.show_in_menu = false
    page.save
    drop = PageDrop.new(page)
    assert !page.show_in_menu?
    assert !drop.show_in_menu
  end

  test 'translated page attributes should return empty array' do
    page = pages(:standout_frontpage)
    drop = PageDrop.new(page, 'se')
    assert_equal 0, drop.translations.size
  end

  test 'translated pages should be available via drop' do
    page = pages(:standout_frontpage)

    page.store_translated_attributes(:title, 'Svenska', 'se')
    page.store_translated_attributes(:title, 'English', 'en')

    drop = PageDrop.new(page, 'se')
    assert_equal 2, drop.translations.size
    assert_equal 'se', drop.translations.first.language
    assert_equal 'en', drop.translations.last.language
  end

end