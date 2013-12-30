module TextFilter
  include ActionView::Helpers::NumberHelper

  def handleize(input)
    Unicode::downcase(input.to_s).gsub(/\s/, '_').gsub(/\W/, '')
  end

  def as_money(input)
    number_to_currency(input.to_f,
      delimiter: ' ',
      format:    @context['website']['money_format'],
      separator: @context['website']['money_separator'],
      unit:      @context['website']['currency_unit']
    )
  end

  def asset_path(file)
    @context['look_id'] ||= PageTemplate.find(@context['page_template_id']).look_id
    "/files/looks/" + @context['look_id'].to_s + "/" + file.to_s
  end

end

Liquid::Template.register_filter(TextFilter)
