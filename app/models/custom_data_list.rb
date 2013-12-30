class CustomDataList < ActiveRecord::Base
  self.table_name = :custom_datas # yeah, I know. But it was inherited from a Rails 2 app.

  # TODO: Move to controller
  attr_accessible :title, :liquid_name, :website_id, :page_template_id, :sort_field_id, :sort_field_order, :page_id, :listconnection

  has_many :custom_data_fields, :dependent => :destroy, :foreign_key => :custom_data_id
  has_many :custom_data_rows, :dependent => :destroy, :foreign_key => :custom_data_id
  belongs_to :page
  belongs_to :page_template
  belongs_to :website

  def visible_fields
    self.custom_data_fields.collect{ |f| f.display_in_list? ? f : nil }.compact
  end

  def to_liquid
    @liquid ||= generate_liquid
  end

  def generate_liquid
    { "id" => self.id,
      "title"  => self.title,
      "items" => self.sorted_data_rows.collect{ |c| CustomDataRowDrop.new(c) },
      "fields" => self.custom_data_fields }
  end

  def sorted_data_rows(paginate = false, page = 1)
    if paginate
      sorted_data = self.custom_data_rows.sort_by{ |row| self.sort_field_type == 'numeric' ? row.json[self.sort_field.to_sym].to_i : row.json[self.sort_field.to_sym].to_s.downcase rescue "" }
      result = self.sort_field_order? ? sorted_data : sorted_data.reverse
      result.paginate(:page => page, :per_page => 30)
    else
      sorted_data = self.custom_data_rows.sort_by{ |row| (self.sort_field_type == 'numeric' ? row.json[self.sort_field.to_sym].to_i : row.json[self.sort_field.to_sym].to_s.downcase) }
      self.sort_field_order? ? sorted_data : sorted_data.reverse
    end
  rescue => e
    puts "Error: #{e.inspect}"
    self.custom_data_rows
  end

  def sort_field
    @sort_field ||= self[:sort_field_id].nil? ? self.cached_custom_data_fields.first.slug : self.cached_custom_data_fields.find(self[:sort_field_id]).slug
  end

  def sort_field_type
    @sort_field_type ||= self[:sort_field_id].nil? ? self.cached_custom_data_fields.first.fieldtype : self.cached_custom_data_fields.find(self[:sort_field_id]).fieldtype
  end

  def cached_custom_data_fields
    @cached_custom_data_fields ||= self.custom_data_fields
  end

end
