class Admin::CsvImportsController < ApplicationController

  require 'csv'
  layout 'webshop'

  def new
    @columns = available_columns
    @categories = current_website.product_categories
    @csv_import = CsvImport.new()
  end

  def create
    # Set up instance variables
    @columns = available_columns
    @categories = current_website.product_categories
    @csv_import = CsvImport.new(csv_import_params)

    if @csv_import.errors?
      # Something went wrong before we started to parse
      return render action: "new"
    end
  end

  def available_columns
    (
      current_website.product_property_keys.map(&:slug) +
      Product.importable_attributes
    ).sort
  end

  private

  def csv_import_params
    params.require(:).permit %i(
      key_col
      category_id
      file
      website_id
      col_sep
    )
  end
end
