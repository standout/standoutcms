# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def display_categories(categories, parent_id)
      ret = "<ul>"
        for category in categories
          if category.parent_id == parent_id
            ret << display_category(category)
          end
        end
      ret << "</ul>"
    end

    def display_category(category)
      ret = "<li>"
      ret << link_to(h(category.title), :action => "show", :id => category)
      ret << display_categories(category.children, category.id) if category.children.any?
      ret << "</li>"
    end

    def file_icon(file)
      unless file.filename.blank?
        if FileTest.exists?("#{Rails.root}/public/images/extensions/file-#{File.extname(file.filename)[1..-1]}.png")
          image_tag("extensions/file-#{File.extname(file.filename)[1..-1]}.png")
        else
          image_tag("extensions/file.png")
        end
      end
    end

    def flash_div *keys
      keys.collect { |key| content_tag(:div, flash[key],
                                       :class => "flash flash-#{key}") if flash[key] }.join
    end

  # Pass an e-mail address to this function and we'll try to return a nice name instead.
  # Example: david.svensson@standout.se => David Svensson
  def email_to_name(email)
    name = email.to_s[/[^@]+/]
    name.split(".").map {|n| n.capitalize }.join(" ")
  end

  def uncapitalize(string)
    string[0, 1].to_s.downcase + string.to_s[1..-1]
  end
end
