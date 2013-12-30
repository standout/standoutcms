module WebsitesHelper
  def order_text_field(form_object, method, attribute)
    value = @website.send(attribute)
    value = nil if value.to_s.empty?
    form_object.send(method, attribute, value: (value or t('order_texts.default')[attribute]))
  end
end
