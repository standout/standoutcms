# encoding: utf-8
class Notifier < BaseMailer
  def signup(user)
    @user = user
    mail(:to => user.email, :subject => 'Welcome to Standout CMS')
  end

  def password_reset_link(user)
    @user = user
    mail(:to => user.email, :subject => 'Standout CMS: new password')
  end

  def order_placed(website, customer, order)
    @website  = website
    @customer = customer
    @order    = order
    @header   = order_text(:order_confirmation_header)
    @footer   = order_text(:order_confirmation_footer)
    I18n.locale = @website.default_language
    mail(
      :from          => @website.email,
      :subject       => order_text(:order_confirmation_title),
      :template_name => 'order_confirmation'
    )
  end

  def order_payed(order)
    @order    = order
    @website  = order.website
    @customer = order.customer
    @header   = order_text(:payment_confirmation_header)
    @footer   = order_text(:payment_confirmation_footer)
    I18n.locale = @website.default_language
    mail(
      :from          => @website.email,
      :subject       => order_text(:payment_confirmation_title),
      :template_name => 'order_confirmation'
    )
  end

  def order_text(attribute)
    value = @website.send(attribute)
    value = nil if value.to_s.empty?
    value or t('order_texts.default')[attribute]
  end
end
