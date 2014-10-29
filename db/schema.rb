# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141024132822) do

  create_table "allowed_pages", force: true do |t|
    t.integer  "page_id"
    t.integer  "user_id"
    t.integer  "website_membership_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", force: true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",       limit: 25
    t.string   "type",                 limit: 25
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "website_id"
    t.integer  "custom_data_row_id"
    t.integer  "custom_data_field_id"
    t.boolean  "processing",                      default: true
    t.string   "title"
    t.integer  "product_category_id"
  end

  add_index "assets", ["assetable_id", "assetable_type", "type"], name: "ndx_type_assetable", using: :btree
  add_index "assets", ["assetable_id", "assetable_type"], name: "fk_assets", using: :btree
  add_index "assets", ["user_id"], name: "asset_website", using: :btree
  add_index "assets", ["user_id"], name: "fk_user", using: :btree

  create_table "blog_categories", force: true do |t|
    t.integer  "website_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_settings", force: true do |t|
    t.integer  "type"
    t.integer  "content_item_id"
    t.integer  "number_of_posts_to_display"
    t.boolean  "allow_comments",             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cart_items", force: true do |t|
    t.integer  "cart_id"
    t.string   "title"
    t.integer  "product_id"
    t.integer  "quantity"
    t.float    "price_per_item"
    t.float    "vat_percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_variant_id"
    t.text     "notes"
    t.string   "api_key"
  end

  create_table "carts", force: true do |t|
    t.integer  "website_id"
    t.integer  "customer_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_key"
    t.string   "reseller"
  end

  create_table "contact_information_sets", force: true do |t|
    t.string   "information_type",          default: "customer"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company_name"
    t.string   "vat_identification_number"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "zipcode"
    t.string   "city"
    t.string   "phone"
    t.integer  "order_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "contact_information_sets", ["order_id"], name: "index_contact_information_sets_on_order_id", using: :btree

  create_table "content_items", force: true do |t|
    t.integer  "page_id"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "for_html_id"
    t.integer  "width"
    t.integer  "height"
    t.text     "text_content",      limit: 2147483647
    t.text     "css",               limit: 16777215
    t.string   "original_filename"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                             default: 0
    t.integer  "extra_id"
    t.string   "language"
    t.integer  "extra_view_id"
    t.boolean  "sticky",                               default: false
    t.boolean  "deleted",                              default: false
  end

  add_index "content_items", ["for_html_id"], name: "index_content_items_on_for_html_id", using: :btree
  add_index "content_items", ["language"], name: "index_content_items_on_language", using: :btree
  add_index "content_items", ["page_id"], name: "index_content_items_on_page_id", using: :btree

  create_table "custom_data_fields", force: true do |t|
    t.string   "name"
    t.string   "fieldtype"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "custom_data_id"
    t.boolean  "display_in_list",   default: true
    t.string   "slug"
    t.string   "image_size_small"
    t.string   "image_size_medium"
    t.string   "image_size_large"
    t.integer  "listconnection"
  end

  add_index "custom_data_fields", ["custom_data_id"], name: "index_custom_data_fields_on_custom_data_id", using: :btree

  create_table "custom_data_rows", force: true do |t|
    t.integer  "custom_data_id"
    t.text     "json",           limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cached_liquid",  limit: 2147483647
    t.datetime "last_cached_at"
    t.string   "slug"
  end

  add_index "custom_data_rows", ["custom_data_id"], name: "index_custom_data_rows_on_custom_data_id", using: :btree

  create_table "custom_datas", force: true do |t|
    t.string   "title"
    t.string   "liquid_name"
    t.integer  "website_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_template_id"
    t.integer  "sort_field_id"
    t.boolean  "sort_field_order", default: false
    t.integer  "page_id"
  end

  create_table "customers", force: true do |t|
    t.integer  "website_id"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",                    default: 0
    t.integer  "attempts",                    default: 0
    t.text     "handler",    limit: 16777215
    t.text     "last_error", limit: 16777215
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "domains", force: true do |t|
    t.integer  "website_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extra_views", force: true do |t|
    t.integer  "extra_id"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extras", force: true do |t|
    t.string   "name"
    t.string   "edit_url"
    t.boolean  "public",      default: true
    t.integer  "website_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_url"
  end

  create_table "extras_websites", id: false, force: true do |t|
    t.integer "extra_id"
    t.integer "website_id"
  end

  create_table "galleries", force: true do |t|
    t.integer  "website_id"
    t.integer  "content_item_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "overview_file_name"
    t.string   "overview_content_type"
    t.integer  "overview_file_size"
    t.datetime "overview_updated_at"
    t.text     "liquid",                limit: 16777215
    t.string   "thumbnail_size"
    t.string   "large_size"
  end

  create_table "gallery_photos", force: true do |t|
    t.integer  "gallery_id"
    t.string   "filename"
    t.integer  "position"
    t.string   "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "languages", force: true do |t|
    t.string   "name"
    t.string   "short_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "look_files", force: true do |t|
    t.integer  "look_id"
    t.string   "content_type"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "looks", force: true do |t|
    t.string   "title"
    t.integer  "website_id"
    t.text     "html",        limit: 16777215
    t.integer  "pages_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "shared",                       default: false
    t.text     "blogentry",   limit: 16777215
  end

  create_table "members", force: true do |t|
    t.integer  "website_id"
    t.boolean  "approved",               default: false
    t.string   "email"
    t.string   "password_digest"
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "postal_street"
    t.string   "postal_zip"
    t.string   "postal_city"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "members", ["website_id", "email"], name: "index_members_on_website_id_and_email", unique: true, using: :btree
  add_index "members", ["website_id", "username"], name: "index_members_on_website_id_and_username", unique: true, using: :btree
  add_index "members", ["website_id"], name: "index_members_on_website_id", using: :btree

  create_table "menus", force: true do |t|
    t.integer  "look_id"
    t.string   "for_html_id"
    t.integer  "levels",           default: 1
    t.integer  "start_level",      default: 0
    t.boolean  "show_submenus",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_template_id"
  end

  create_table "notices", force: true do |t|
    t.integer  "user_id"
    t.integer  "website_id"
    t.integer  "page_id"
    t.text     "message",    limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "website_id"
    t.integer  "customer_id"
    t.integer  "cart_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "payment_type"
    t.boolean  "inquiry",      default: false
  end

  create_table "page_templates", force: true do |t|
    t.integer  "look_id"
    t.string   "slug"
    t.string   "name"
    t.boolean  "default_template",                  default: false
    t.boolean  "partial",                           default: false
    t.text     "html",             limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.integer  "website_id"
    t.string   "title"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                                    default: 0
    t.integer  "parent_id"
    t.integer  "look_id"
    t.string   "seo_title"
    t.string   "english_title"
    t.integer  "level"
    t.boolean  "login_required",                              default: false
    t.boolean  "deleted",                                     default: false
    t.string   "direct_link"
    t.boolean  "blogentry",                                   default: false
    t.integer  "page_template_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "proposed_parent_id"
    t.string   "password_hash"
    t.text     "translated_attributes_data", limit: 16777215
    t.datetime "published_at"
  end

  create_table "payments", force: true do |t|
    t.boolean  "paid",       default: false
    t.datetime "paid_at"
    t.float    "paid_price"
    t.integer  "order_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "source"
    t.string   "token"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content",          limit: 16777215
    t.boolean  "allow_comments",                    default: true
    t.integer  "website_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blog_category_id"
    t.string   "slug"
    t.string   "language"
  end

  create_table "product_categories", force: true do |t|
    t.integer  "website_id"
    t.string   "title"
    t.text     "description", limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "parent_id"
  end

  create_table "product_categories_products", id: false, force: true do |t|
    t.integer "product_id"
    t.integer "product_category_id"
  end

  create_table "product_images", force: true do |t|
    t.integer  "product_id"
    t.integer  "website_id"
    t.integer  "position",            default: 0
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.integer  "image_uploaded_at"
    t.integer  "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_category_id"
  end

  create_table "product_property_keys", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "website_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "data_type"
  end

  add_index "product_property_keys", ["website_id"], name: "index_product_property_keys_on_website_id", using: :btree

  create_table "product_property_values", force: true do |t|
    t.integer  "product_property_key_id"
    t.integer  "product_variant_id"
    t.integer  "product_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "string"
    t.integer  "integer"
  end

  add_index "product_property_values", ["product_id"], name: "index_product_property_values_on_product_id", using: :btree
  add_index "product_property_values", ["product_property_key_id"], name: "index_product_property_values_on_product_property_key_id", using: :btree
  add_index "product_property_values", ["product_variant_id"], name: "index_product_property_values_on_product_variant_id", using: :btree

  create_table "product_relations", force: true do |t|
    t.integer  "product_id"
    t.integer  "related_product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_variants", force: true do |t|
    t.integer  "product_id"
    t.string   "color"
    t.string   "size"
    t.string   "material"
    t.float    "price"
    t.integer  "inventory"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.integer  "website_id"
    t.string   "title"
    t.text     "description",    limit: 16777215
    t.float    "price"
    t.float    "vat_percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.integer  "vendor_id"
    t.datetime "deleted_at"
  end

  create_table "releases", force: true do |t|
    t.integer  "website_id"
    t.text     "release_notes"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reserved_urls", force: true do |t|
    t.integer  "website_id"
    t.string   "url"
    t.integer  "item_id"
    t.string   "item_type"
    t.string   "language",   limit: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servers", force: true do |t|
    t.integer  "website_id"
    t.integer  "order",             default: 0
    t.string   "name"
    t.string   "host"
    t.string   "username"
    t.string   "password"
    t.string   "publish_dir"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_published_to"
    t.string   "root_url"
    t.string   "mysql_host"
    t.string   "mysql_database"
    t.string   "mysql_username"
    t.string   "mysql_password"
    t.string   "domain"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id",                  null: false
    t.text     "data",       limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "shipping_costs", force: true do |t|
    t.string   "cost_type"
    t.float    "from_value"
    t.float    "to_value"
    t.float    "cost"
    t.integer  "website_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "shipping_costs", ["website_id"], name: "index_shipping_costs_on_website_id", using: :btree

  create_table "translated_page_attributes", force: true do |t|
    t.integer  "page_id"
    t.string   "language_short_code"
    t.string   "attribute_name"
    t.string   "attribute_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translated_page_attributes", ["language_short_code"], name: "index_translated_page_attributes_on_language_short_code", using: :btree
  add_index "translated_page_attributes", ["page_id"], name: "index_translated_page_attributes_on_page_id", using: :btree

  create_table "url_pointers", force: true do |t|
    t.string   "path"
    t.integer  "website_id"
    t.integer  "page_id"
    t.string   "language"
    t.integer  "custom_data_row_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.integer  "product_id"
    t.integer  "product_category_id"
    t.integer  "vendor_id"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",         default: false
    t.string   "locale"
  end

  create_table "users_websites", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "website_id"
  end

  create_table "vendors", force: true do |t|
    t.integer  "website_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "versions", force: true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "user_name"
    t.text     "modifications",  limit: 16777215
    t.integer  "number"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versions", ["created_at"], name: "index_versions_on_created_at", using: :btree
  add_index "versions", ["number"], name: "index_versions_on_number", using: :btree
  add_index "versions", ["tag"], name: "index_versions_on_tag", using: :btree
  add_index "versions", ["user_id", "user_type"], name: "index_versions_on_user_id_and_user_type", using: :btree
  add_index "versions", ["user_name"], name: "index_versions_on_user_name", using: :btree
  add_index "versions", ["versioned_id", "versioned_type"], name: "index_versions_on_versioned_id_and_versioned_type", using: :btree

  create_table "website_memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "website_id"
    t.boolean  "website_admin",   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "restricted_user", default: false
  end

  create_table "websites", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_key"
    t.string   "domain"
    t.string   "default_language"
    t.integer  "blog_page_id"
    t.integer  "blog_category_page_id"
    t.integer  "look_id"
    t.string   "subdomain"
    t.text     "settings"
    t.string   "email"
    t.string   "domainaliases"
  end

end
