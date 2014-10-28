class BaseMailer < ActionMailer::Base
  default from: "support@standout.se"

  private

  def liquid(slug, stuff = {})
    if template = @website.page_templates.find_by(slug: slug)
      Liquid::Template.parse(template.html.to_s).render(stuff)
    else
      "You need a template named #{slug} to modify this email body"
    end
  end

  def subject(subject_symbol, options = {})
    mailer = self.class.to_s.underscore
    I18n.t("#{mailer}.#{subject_symbol}", options)
  end
end
