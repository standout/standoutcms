require 'test_helper'

class CustomDataRowTest < ActiveSupport::TestCase

  def setup
    @list = CustomDataList.create(:website_id => websites(:standout).id, :title => 'test', :liquid_name => 'test')
  end

  test 'should be able to create a custom data row' do
    row = CustomDataRow.new(:custom_data_id => @list.id)
    assert row.save!
  end

  test 'adding a custom data row should also add a corresponding url pointer' do
    row = CustomDataRow.new(:custom_data_id => @list.id)
    assert row.save
    assert UrlPointer.where(:custom_data_row_id => row.id).count == 1
  end

  test 'custom data rows should be sortable by numeric value' do

    # Add a new field with numeric value
    field = CustomDataField.create(:name => 'age', :fieldtype => 'numeric', :custom_data_id => @list.id )

    # Add three row items
    CustomDataRow.create(:custom_data_id => @list.id, :age => 1)
    CustomDataRow.create(:custom_data_id => @list.id, :age => 20)
    CustomDataRow.create(:custom_data_id => @list.id, :age => 3)

    # Specify sorting on the list
    @list.update_attribute(:sort_field_id, field.id)
    @list.update_attribute(:sort_field_order, true)

    # See if they are sorted correctly
    assert_equal 20, @list.sorted_data_rows.last.age

    # Test with paginaton
    assert_equal 20, @list.sorted_data_rows(true, 1).last.age

  end

  test 'row can have a page' do
    @list.update_attribute :page_id, @list.website.pages.first.id
    row = CustomDataRow.new(:custom_data_id => @list.id)
    assert row.page == @list.website.pages.first
  end

end
