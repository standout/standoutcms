module ContentItemsHelper
  def tool_button(src, javascript, alt, title)
    image_tag src, { :class => 'tool_button', :alt => alt, :title => title, :onclick => javascript }
  end
  
   def delete_content_item(id)
     content_tag :div , image_tag('delete.png', { :onclick => "parent.remove_item(#{id})"}), { :class => 'delete_content_item', :style => "position: absolute; width: 16px; height: 16px; top: 50%; right: 0; overflow: hidden; display: none;" }
  end 
end