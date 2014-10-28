# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page_template do
    factory :member_signup_page_template do
      slug "member_signup"
      html "<h1>{{website.title}}</h1>"
    end

    factory :member_signin_page_template do
      slug "member_signup"
      html "<h1>{{website.title}}</h1>"
    end

    factory :member_approved_email_page_template do
      slug "member_approved_email"
      html "Hej {{member.email}}"
    end

    factory :member_password_reset_email_page_template do
      slug "member_password_reset_email"
      html "Klicka <a href=\"{{member.password_reset_url}}\">här</a>"
    end

    factory :member_password_reset_new_page_template do
      slug "member_password_reset_new"
      html "Fyll i din e-postadress här"
    end

    factory :member_password_reset_edit_page_template do
      slug "member_password_reset_edit"
      html "Ange ditt nya lösenord här"
    end
  end
end
