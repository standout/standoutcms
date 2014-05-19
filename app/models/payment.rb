class Payment < ActiveRecord::Base
  belongs_to :order

  before_create :generate_token

  def update_payment(paid, source = nil)
    if paid == true
      self.update(
        paid: true,
        paid_at: DateTime.now,
        paid_price: self.order.total_price,
        source: source
      )
      mail = Notifier.order_payed(self.order)
      mail[:to] = self.order.website.email
      mail.deliver
      mail[:to] = self.order.customer.email
      mail.deliver
    else
      self.update(
        paid: false,
        paid_at: nil,
        paid_price: nil,
        source: nil)
    end
  end

  def status
    self.paid? ? I18n.t('paid') : I18n.t('not_paid')
  end

  private

  def generate_token
    self.token = SecureRandom.hex
  end
end
