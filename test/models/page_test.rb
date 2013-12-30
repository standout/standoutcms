# encoding: utf-8
require 'test_helper'
require 'nokogiri'

class PageTest < ActiveSupport::TestCase

  test 'should display pages with utf-8 in title' do
    p = pages(:standout_frontpage)
    p.title = "Växjö"
    assert p.save
    html = p.complete_html
    assert html.match(/Växjö/)
    doc = Nokogiri::HTML(html)
    assert_equal(3, doc.css('#menu li').size)
  end

  test 'should show in menu' do
    p = pages(:standout_frontpage)
    p.show_in_menu = true
    assert p.save
    assert p.show_in_menu
  end

  test 'should not show in menu' do
    p = pages(:standout_frontpage)
    p.show_in_menu = false
    assert p.save
    assert !p.show_in_menu
  end

  test 'should save translated attributes' do
    p = pages(:standout_frontpage)
    p.store_translated_attributes('title', 'Min hemsida', 'sv')
    p.store_translated_attributes('title', 'My homepage', 'en')
    p.store_translated_attributes('show_in_menu', true, 'sv')
    p.store_translated_attributes('show_in_menu', false, 'en')
    assert p.title('sv') == 'Min hemsida'
    assert p.title('en') == 'My homepage'
    assert p.show_in_menu('sv') == true
    assert p.show_in_menu('en') == false
  end

  test 'should return translations' do
    p = pages(:standout_frontpage)
    assert p.store_translated_attributes('title', 'Sida', 'sv')
    assert p.store_translated_attributes('title', 'Page', 'en')
    p.save!

    assert_equal 2, p.reload.translations.size

  end


end
