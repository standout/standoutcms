module PagesHelper
  def nested_set_list_for(pages, current_ids = [], level = 0)
    returning "" do |html|
      unless pages.empty?
        level = level + 1
        html << "<ul>" 
        pages.each do |node|
          if !node.hide_from_menu? || @editing
            cls = " current" if current_ids.include?(node.id.to_i)
            metadata = " #{"v-hidden " if node.hide_from_menu?} {node_id : #{node.id}}" if @editing
            html << %(<li class="level-#{level}#{cls}#{metadata}">#{link_to node.title, node.public_path})
            html << nested_set_list_for(node.children, current_ids, level) unless node.children.empty?
            html << "</li>"
          end
        end
        html << "</ul>"
      end
    end
  end

  def padded_page_name(page,repeat = 2,padder = "&nbsp;")
    returning "" do |result|
      (page.level*repeat).times { result << "#{padder} " }
      title = page.show_in_menu? ? page.title : "[#{page.title}]"
      result << title
    end
  end

  # returns css class for page in menu
  def selected(current_page, menu_page)
    if menu_page.marked?(current_page)
      selected = 'selected'
    else
      selected = 'unselected'
    end
  end
end
