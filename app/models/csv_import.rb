require 'csv'

class CsvImport
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :created_rows_count
  attr_accessor :key_col, :category_id, :file, :website_id, :col_sep

  validates_presence_of :key_col, :category_id, :file, :website_id

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end

    @invalid_rows = Hash.new
    @collected_cols = []
    @missing_cols = []
    @redundant_cols = []
    @key_col_found = false
    # Statistics
    @saved_rows_count = 0
    @created_rows_count = 0
    @total_rows_count = 0

    if attributes.size > 0
      # Error checking variables
      @column_missing_errors = ""
      @column_redundant_errors = ""
      @key_missing_error = ""

      @dynamic_columns = ProductPropertyKey
        .where(website_id: self.website_id).map(&:slug)
      @columns = @dynamic_columns + Product.attribute_names

      parse_csv()
    end
  end

  def persisted?
    false
  end

  def new_record?
    self.file.nil?
  end

  def missing_columns
    @missing_cols.empty? ? nil : I18n.translate(:csv_import_missing_cols)+(@missing_cols.join(', ')).force_encoding('UTF-8')
  end

  def redundant_columns
    @redundant_cols.empty? ? nil : I18n.translate(:csv_import_redundant_cols)+(@redundant_cols.join(', ')).force_encoding('UTF-8')
  end

  def key_missing
    @key_col_found ? nil : I18n.translate(:csv_import_missing_key_col)
  end

  def error_count
    @missing_cols.size + @redundant_cols.size + (@key_col_found ? 0 : 1)
  end

  def errors?
    not (@missing_cols.empty? and @redundant_cols.empty? and @key_col_found)
  end

  def invalid_rows
    @invalid_rows
  end

  def parsing_errors?
    not @invalid_rows.empty?
  end

  def rows_count
    @total_rows_count
  end

  def failed_rows_count
    @invalid_rows.size
  end

  def successful_rows_count
    @total_rows_count - @invalid_rows.size
  end

  def updated_rows_count
    successful_rows_count - @created_rows_count
  end

  private

  def parse_csv
    # Get rows from file
    csv_contents = CSV.read(self.file.tempfile, col_sep: @col_sep || ',')
    @total_rows_count = csv_contents.length - 1
    header_row = csv_contents.shift

    # Check header row for errors
    header_row.each do |col|
      unless @columns.include? col
        # The column is not in the model
        @redundant_cols << col
      end
      @collected_cols << col
      # Make sure the given key column exists in the CSV file
      @key_col_found = (@key_col_found or (self.key_col == col))
    end

    @columns.each do |col|
      # The column is in the model, check if it is required
      @missing_cols << col if Product.validators_on(col).map(&:class).include? ActiveRecord::Validations::PresenceValidator and not @collected_cols.include? col
    end

    # Only continue if we have found no errors
    unless self.errors?
      csv_contents.each_with_index do |row, index|
        arguments = Hash.new

        row.each_with_index do |val, i|
          arguments.store(header_row[i].to_s, val) unless val == nil
        end

        product = nil

        if @dynamic_columns.include?(key_col.to_s)
          key = ProductPropertyKey.where(
            slug: key_col, website_id: website_id
          ).first
          value_where = {product_property_key_id: key.id}
          value_where[key.data_type] = arguments[key_col.to_s]
          value = ProductPropertyValue.where(value_where).first
          product = Product.find(value.product_id) if value rescue product = nil
        else
          product = Product.send("find_by_#{self.key_col}", arguments[self.key_col.to_s])
        end

        # We have to
        unless product
          product = Product.new()

          # Special attributes
          product.product_category_ids = self.category_id
          product.website_id = self.website_id
          product.title = arguments.delete('title')
          @created_rows_count += 1 if product.save
        end

        # Set all attributes from CSV
        # TODO: Update this to reflect getter and setters changes in dyn. attr.
        arguments.each do |key, value|
          if product.has? key
            product.send(key+"=", value)
          else
            product.update_dynamic_attributes( { key => value } )
          end
        end

        # Save or update, storing errors if they occur
        @invalid_rows.store(index+1, [row, product.errors.full_messages]) unless product.save
      end
    end
  end

end
