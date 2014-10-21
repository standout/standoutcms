# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member do
    sequence(:email) { |n| "member-#{n}@example.com" }
    password "password"
    password_confirmation "password"
    password_digest "$2a$10$ykaAaxHyeXCQRszLn5Rp5ewYOHlSwgk3NgB34vOfGxIMNaM6Si4y6"
  end
end
