module ArrayFilter
  def unique(input)
    input.to_a.uniq
  end
  
  def random(input)
    input.to_a.choice
  end
end

Liquid::Template.register_filter(ArrayFilter)