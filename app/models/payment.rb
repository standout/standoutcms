class Payment < ActiveRecord::Base
  belongs_to :order

  def update_payment(paid, source = nil)
    if paid == true
      self.update_attributes(
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
      self.update_attributes(
        paid: false,
        paid_at: nil,
        paid_price: nil,
        source: nil)
    end
  end

  def status
    self.paid? ? I18n.t('paid') : I18n.t('not_paid')
  end
end
