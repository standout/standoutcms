# We had some issues with storing international chars in the database,
# and found out it used Latin1 by default. This migration fixes the tables
# that were creating using Latin1.
# For new tables this should be defined specifically.

class AddUtfSupportToOldTables < ActiveRecord::Migration
  def up
    tables = ["allowed_pages", "assets", "blog_categories", "blog_settings", "cart_items", "carts", "delayed_jobs", "domains", "galleries", 
      "gallery_photos", "languages", "menus", "notices", "posts", "product_categories", "product_categories_products", "product_images", 
      "product_relations", "products", "content_items", "pages", "page_templates", "looks", "look_files", "versions", "website_memberships", 
      "websites", "users_websites", "users", "url_pointers", "custom_datas", "custom_data_fields", "custom_data_rows", "servers", "sessions"]
    say_with_time("Convering tables to UTF-8") do
      tables.each do |table|
        say "Converting #{table} to UTF-8"
        execute "ALTER TABLE #{table} CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci"
      end
    end
    puts "Converting database to UTF-8."
    execute "ALTER DATABASE standoutcms CHARACTER SET utf8"
  end
  
  def down
    tables = ["allowed_pages", "assets", "blog_categories", "blog_settings", "cart_items", "carts", "delayed_jobs", "domains", "galleries", 
      "gallery_photos", "languages", "menus", "notices", "posts", "product_categories", "product_categories_products", "product_images", 
      "product_relations", "products", "content_items", "pages", "page_templates", "looks", "look_files", "versions", "website_memberships", 
      "websites", "users_websites", "users", "url_pointers", "custom_datas", "custom_data_fields", "custom_data_rows", "servers", "sessions"]
      say_with_time("Converting to Latin-1 ...") do 
        tables.each do |table|
          execute "ALTER TABLE #{table} CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci"
          say "Table #{table} was converted."
        end
      end
    puts "Converting database to Latin-1."
    execute "ALTER DATABASE standoutcms CHARACTER SET latin1"
  end
end
