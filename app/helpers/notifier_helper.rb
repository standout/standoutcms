module NotifierHelper
  def money_value(value)
    formats = {'SEK' => '%n %u', 'USD' => '%u%n'}
    number_to_currency(value,
      unit: @website.currency_unit,
      format: formats[@website.webshop_currency]
    )
  end

  def uncapitalize(string)
    string.to_s[0, 1].downcase + string.to_s[1..-1].to_s
  end
end
