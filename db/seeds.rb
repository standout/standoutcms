# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

puts "# Standout CMS"

# Let the user create an admin
if User.all.size < 1
  user = User.new(:email => "admin@example.com")
  user.password = "abc123"
  user.admin = true
  user.save
end


# Languages
puts "- adding languages"
Language.create(:short_code => 'sv', :name => 'Svenska')
Language.create(:short_code => 'en', :name => 'English')

# Create a site
puts "- adding default site"
w = Website.create!(:title => 'Development', :subdomain => 'development')

# Add product categories
puts "- adding product categories"
pc1 = ProductCategory.create(:website_id => w.id, :title => 'Books')
pc2 = ProductCategory.create(:website_id => w.id, :title => 'Screencasts')

# Add products
puts "- adding products"
Product.create(:website_id => w.id, :product_category_ids => [pc1.id], :title => 'Agile Web Development with Rails', :description => "A nice book.", :price => 29.95, :vat_percentage => 25.0)
Product.create(:website_id => w.id, :product_category_ids => [pc1.id], :title => 'Rails recipes', :description => "Not food, just code.", :price => 24.95, :vat_percentage => 25.0)

# Add shipping costs
puts '- adding shipping costs'
w.shipping_costs.create(:cost_type => 'price', :to_value => 300, :cost => 100)
w.shipping_costs.create(:cost_type => 'price', :from_value => 300, :cost => 0)

puts "---------------"
puts "Done."
