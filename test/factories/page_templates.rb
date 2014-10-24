# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page_template do
    factory :member_approved_email_page_template do
      slug "member_approved_email"
      html "Hej {{member.email}}"
    end
  end
end
