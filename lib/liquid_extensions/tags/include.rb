class Include < Liquid::Include
  def initialize(tag_name, markup, tokens)
    super
  end
  
  def render(context)
    partial = Liquid::Template.parse(PageTemplate.find(context['page_template_id']).look.page_templates.find(:first, :conditions => { :slug => @template_name.gsub(/\W/, '') }).html)      
    variable = context[@variable_name || @template_name[1..-2]]
    
    context.stack do
      @attributes.each do |key, value|
        context[key] = context[value]
      end

      if variable.is_a?(Array)
        variable.collect do |variable|            
          context[@template_name[1..-2]] = variable
          partial.render(context)
        end
      else      
        context[@template_name[1..-2]] = variable
        partial.render(context)
      end
    end
  end
end

Liquid::Template.register_tag('include', Include)