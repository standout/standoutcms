class CustomDataRowDrop < Liquid::Drop

  def initialize(row)
    @row = row
  end

  # We have some dynamic fields on custom data rows that
  # needs to be handled.
  # TODO: could probably be refactored heavily, the code in this method
  # is just moved from the old model.
  def before_method(method)

    # Just delegate internally if this method is already defined
    return send(method) if respond_to?(method)

    # Find out which field to match
    @row.fields.each do |field|
        next if field.name_to_slug != method

        # Files
        if field.fieldtype == 'file'
          return @row.files_for_data(field)

        elsif field.fieldtype == 'password'
          return Digest::SHA256.hexdigest(@row.custom_data_list.website.api_key.to_s + self.json[field.name_to_slug.to_sym].to_s)


        elsif field.fieldtype == 'numeric'
          return @row.send(field.name_to_slug.to_sym).to_i

        # Images have several different formats
        elsif field.fieldtype == 'image'
          if @row.images_for(field).empty?
            return { "thumb" => '', "small" => '', "medium" => '', "large" => '', "original" => '' }
          else
            all_images = @row.images_for(field)
            all_image_array = all_images.collect{ |image|
                { "thumb" => image.url(:thumb),
                "small" => image.url(:small),
                "medium" => image.url(:medium),
                "large" => image.url(:large),
                "original" => image.url(:original),
                "title" => image.title } }
              
            return {
              # For backwards compatibility, return the one record first
              "thumb" => all_images.last.url(:thumb),
              "small" => all_images.last.url(:small),
              "medium" => all_images.last.url(:medium),
              "large" => all_images.last.url(:large),
              "original" => all_images.last.url(:original),
              "title" => all_images.last.title,

              # TODO: Refactoring suggestion: move to Drop
              "all" => all_image_array
              
              }
          end

        # Connected to another custom data list
        elsif field.fieldtype == 'listconnection' || field.fieldtype == 'listconnections'
          # Id of the row we are looking for
          row_ids = @row.send(field.name_to_slug.to_sym)
          begin
            if field.connected_list && field.connected_list.custom_data_rows.find(row_ids.to_a)
              # Return liquified data row from the connected list
              if field.fieldtype == 'listconnection'
                return CustomDataRowDrop.new(field.connected_list.custom_data_rows.find(row_ids.to_a.first))
              else
                return field.connected_list.custom_data_rows.find(row_ids.to_a).map{ |row| CustomDataRowDrop.new(row) }
              end
            end
          rescue
            # Sometimes the connection fails because of wierd settings
          end
        # Just return the value from json
        else
          return @row.send(field.name_to_slug.to_sym) rescue nil
        end
      end
    return false
  end

  def id
    @row.id
  end

  def created_at
    @row.created_at
  end

  def updated_at
    @row.updated_at
  end

  def cms_title
    @row.cms_title
  end

  def url
    @row.url
  end

  # Return the complete path to this item beginning with /
  def path
    "/#{@row.slug}"
  end

  def language
    @row.language
  end


end
