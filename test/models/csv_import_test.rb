require 'test_helper'

class CsvImportTest < ActiveSupport::TestCase

  def setup
    csv_working         = ActionDispatch::Http::UploadedFile.new({ filename: "products.csv", type: "text/csv", head: "Content-Disposition: form-data; name=\"csv_import[file]\"; filename=\"products.csv\"\r\nContent-Type: text/csv\r\n", tempfile: fixture_file_upload("files/working.csv",'text/csv')})
    csv_working_dynamic = ActionDispatch::Http::UploadedFile.new({ filename: "products.csv", type: "text/csv", head: "Content-Disposition: form-data; name=\"csv_import[file]\"; filename=\"products.csv\"\r\nContent-Type: text/csv\r\n", tempfile: fixture_file_upload("files/working_dynamic.csv",'text/csv')})
    csv_broken_items    = ActionDispatch::Http::UploadedFile.new({ filename: "products.csv", type: "text/csv", head: "Content-Disposition: form-data; name=\"csv_import[file]\"; filename=\"products.csv\"\r\nContent-Type: text/csv\r\n", tempfile: fixture_file_upload("files/broken_items.csv",'text/csv')})
    csv_missing_column  = ActionDispatch::Http::UploadedFile.new({ filename: "products.csv", type: "text/csv", head: "Content-Disposition: form-data; name=\"csv_import[file]\"; filename=\"products.csv\"\r\nContent-Type: text/csv\r\n", tempfile: fixture_file_upload("files/missing_column.csv",'text/csv')})
    csv_unknown_column  = ActionDispatch::Http::UploadedFile.new({ filename: "products.csv", type: "text/csv", head: "Content-Disposition: form-data; name=\"csv_import[file]\"; filename=\"products.csv\"\r\nContent-Type: text/csv\r\n", tempfile: fixture_file_upload("files/unknown_column.csv",'text/csv')})
    @params_csv_working         = { key_col: "title", category_id: product_categories(:one).id, file: csv_working,         website_id: websites(:standout).id}
    @params_csv_working_dynamic = { key_col: "title", category_id: product_categories(:one).id, file: csv_working_dynamic, website_id: websites(:standout).id}
    @params_key_col_error       = { key_col: "smurf", category_id: product_categories(:one).id, file: csv_working,         website_id: websites(:standout).id}
    @params_csv_broken_items    = { key_col: "title", category_id: product_categories(:one).id, file: csv_broken_items,    website_id: websites(:standout).id}
    @params_csv_unknown_column  = { key_col: "title", category_id: product_categories(:one).id, file: csv_unknown_column,  website_id: websites(:standout).id}
    @params_csv_unknown_key     = { key_col: "smurf", category_id: product_categories(:one).id, file: csv_working,         website_id: websites(:standout).id}
    @params_csv_missing_column  = { key_col: "title", category_id: product_categories(:one).id, file: csv_missing_column,  website_id: websites(:standout).id}
  end

  # Tests on an uninitialized importer

  test 'Initializing an empty CSV importer should work' do
    importer = CsvImport.new()
    assert_equal importer.class.name, CsvImport.to_s
  end

  test 'An empty CSV importer should report itself as new_record?' do
    importer = CsvImport.new()
    assert importer.new_record?
  end

  test 'An empty CSV importer should not have found the key column' do
    importer = CsvImport.new()
    assert importer.errors?
    assert_not_nil importer.key_missing
  end

  test 'An empty CSV importer should have no errors for columns' do
    importer = CsvImport.new()
    assert_nil importer.missing_columns
    assert_nil importer.redundant_columns
  end

  # Tests on an initialized importer with a working csv
  # Imports on an empty database

  test 'Initializing an CSV importer with params should work' do
    importer = CsvImport.new(@params_csv_working)
    assert_not_nil importer
  end

  test 'Importing a correct CSV file should result in products being created' do
    importer = CsvImport.new(@params_csv_working)
    assert_not_nil Product.find_by_title("The Ruby Programming Language")
    assert_not_nil Product.find_by_title("Ruby on Rails 3 Tutorial: Learn Rails by Example")
    assert_not_nil Product.find_by_title("Programming Ruby 1.9: The Pragmatic Programmers' Guide")
    assert_not_nil Product.find_by_title("The Book Of Ruby")
  end

  test 'Importing a correct CSV file should result in products with these prices' do
    importer = CsvImport.new(@params_csv_working)
    assert_equal Product.find_by_title("The Ruby Programming Language").price, 23.58
    assert_nil   Product.find_by_title("Ruby on Rails 3 Tutorial: Learn Rails by Example").price
    assert_equal Product.find_by_title("Programming Ruby 1.9: The Pragmatic Programmers' Guide").price, 29.97
    assert_equal Product.find_by_title("The Book Of Ruby").price, 26.34
  end

  test 'Importing a correct CSV file should result in products with these descriptions' do
    importer = CsvImport.new(@params_csv_working)
    assert_equal Product.find_by_title("The Ruby Programming Language").description, "A must have!"
    assert_equal Product.find_by_title("Ruby on Rails 3 Tutorial: Learn Rails by Example").description, "Get it now!!!"
    assert_equal Product.find_by_title("Programming Ruby 1.9: The Pragmatic Programmers' Guide").description, "You don't know how much you have missed this book..."
    assert_equal Product.find_by_title("The Book Of Ruby").description, "Awesome book!"
  end

  test 'Importing with dynamic attributes should work' do
    products_before = Product.all
    importer = CsvImport.new(@params_csv_working_dynamic)
    products_added = Product.all - products_before
    products_added.each do |product|
      assert_not_nil product.dynamic_attributes[:pages]
      assert_not_nil product.dynamic_attributes[:isbn]
      assert product.dynamic_attributes[:pages] > 0
      assert product.dynamic_attributes[:isbn].to_s.length >= 10
    end
  end

  # Imports with prepopulated database

  test 'Importing a CSV over exisiting products should work' do
    importer  = CsvImport.new(@params_csv_working)
    assert_not_nil importer
    p1 = Product.last
    importer  = CsvImport.new(@params_csv_working)
    assert_not_nil importer
    p2 = Product.last
    assert_equal p1, p2
  end

  test 'Importing a CSV over exisiting products should update the product attributes' do
    importer  = CsvImport.new(@params_csv_working)
    assert_not_nil importer
    Product.all.each do |p|
      p.price = 0.0
      p.save
    end
    importer  = CsvImport.new(@params_csv_working)
    assert_not_nil importer
    assert_equal Product.find_by_title("The Ruby Programming Language").price, 23.58
    assert_equal Product.find_by_title("Programming Ruby 1.9: The Pragmatic Programmers' Guide").price, 29.97
    assert_equal Product.find_by_title("The Book Of Ruby").price, 26.34
  end

  test 'Importing a CSV over existing products should not update the product attributes if the CSV files has no value for them' do
    importer  = CsvImport.new(@params_csv_working)
    assert_not_nil importer
    Product.all.each do |p|
      p.price = 0.0
      p.save
    end
    importer  = CsvImport.new(@params_csv_working)
    assert_not_nil importer
    assert_not_nil Product.find_by_title("Ruby on Rails 3 Tutorial: Learn Rails by Example").price
  end

  # Error generation tests
  # Header errors
  # Make sure we have good error reporting back to the user

  test 'Importing CSV with missing required column in header should raise an error' do
    importer = CsvImport.new(@params_csv_missing_column)
    assert importer.error_count > 0
    assert_match /title/, importer.missing_columns
  end

  test 'Importing CSV with unknown key column should raise an error' do
    importer = CsvImport.new(@params_csv_unknown_key)
    assert_not_nil importer.key_missing
  end

  test 'Importing CSV with unknown columns in header should fail those names' do
    importer = CsvImport.new(@params_csv_unknown_column)
    assert_not_nil importer.redundant_columns
    assert_match /smurf_head_counter/, importer.redundant_columns
  end

  # Make sure not to pollute the DB on errors

  test 'Importing CSV with missing required column in header should not produce any items in the database' do
    before_count = Product.all.count
    importer = CsvImport.new(@params_csv_missing_column)
    assert_equal before_count, Product.all.count
  end

  test 'Importing CSV with unknown key column should not produce any items in the database' do
    before_count = Product.all.count
    importer = CsvImport.new(@params_csv_unknown_key)
    assert_equal before_count, Product.all.count
  end

  test 'Importing CSV with unknown columns in header should not produce any items in the database' do
    before_count = Product.all.count
    importer = CsvImport.new(@params_csv_unknown_column)
    assert_equal before_count, Product.all.count
  end

  # Row errors
  # Basic broken

  test 'Importing a CSV with broken items should only fail the broken items' do
    assert_difference 'Product.count', 2 do
      importer = CsvImport.new(@params_csv_broken_items)
    end
  end

  test 'Importing a CSV with broken items should generate errors for those items' do
    importer = CsvImport.new(@params_csv_broken_items)
    assert importer.parsing_errors?
    assert_equal importer.invalid_rows.count, 1
    # Make sure it sets the error message to the right row
    assert_equal importer.invalid_rows.first[0], 4
    # Check that it's the right row
    assert_match /Awesome\ book!/, importer.invalid_rows.first[1][0].join(',')
    # Check that it's the right error
    # assert_match /title/i, importer.invalid_rows.first[1][1][0]
  end

end
