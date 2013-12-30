module ExtrasHelper
  
  def plugin_tab(linkname, tabname)
    link_to_function linkname, "enable_tab('#{tabname}')", :class => 'plugin_tab_link'
  end
  
end
