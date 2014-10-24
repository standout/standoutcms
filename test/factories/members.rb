# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member do
    sequence(:email) { |n| "member-#{n}@example.com" }
    first_name "Glenn"
    last_name "Glennsson"
    approved false
    postal_street "Västergatan 6"
    postal_zip 35237
    postal_city "Växjö"

    factory :approved_member do
      approved true
      password_digest "$2a$10$ykaAaxHyeXCQRszLn5Rp5ewYOHlSwgk3NgB34vOfGxIMNaM6Si4y6"
    end
  end
end
