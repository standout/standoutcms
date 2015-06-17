# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member do
    sequence(:email) { |n| "member-#{n}@example.com" }
    first_name "Glenn"
    last_name "Glennsson"
    approved false
    postal_street "Västergatan 6"
    postal_zip 35230
    postal_city "Växjö"
    username "glenn"
    phone "012-345 67 89"

    factory :approved_member do
      approved true
      password_digest "$2a$10$ykaAaxHyeXCQRszLn5Rp5ewYOHlSwgk3NgB34vOfGxIMNaM6Si4y6"

      factory :member_with_password_token do
        password_reset_token "e2U7NN5ej4AaP7VwMq3VhQ"
        password_reset_sent_at 1.seconds.ago
      end
    end
  end
end
