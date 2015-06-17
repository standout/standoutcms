# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :website do
    domain "standoutcms.se"
    subdomain "website"
    email "website@example.com"
    title "Website"
  end
end
