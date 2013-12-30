module PageTemplatesHelper
  def page_template_icon(page_template)
    type = ["liquid", "partial"][page_template.partial? ? 1 : 0]
    image_tag "extensions/file-#{type}.png"
  end
end
