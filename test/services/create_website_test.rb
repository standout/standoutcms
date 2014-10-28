require "test_helper"

describe CreateWebsite do
  let(:website) { build :website }

  describe "after create" do
    before { CreateWebsite.call(website) }

    def must_have_template(slug)
      refute_nil website.page_templates.find_by(slug: slug),
        "Expected website have a template named #{slug}"
    end

    def must_have_partial(slug)
      refute_nil website.page_templates.find_by(slug: slug, partial: true),
        "Expected website have a partial named #{slug}"
    end

    it { must_have_template "cart" }
    it { must_have_template "member_password_reset_edit" }
    it { must_have_template "member_password_reset_new" }
    it { must_have_template "member_signin" }
    it { must_have_template "member_signup" }

    it { must_have_partial "header" }
    it { must_have_partial "member_approved_email" }
    it { must_have_partial "member_password_reset_email" }
    it { must_have_partial "member_signout_form" }
  end
end
