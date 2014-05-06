module ModelSearch

  def search_and_filter(query_hash)
    if query_hash.class.name == "ActionController::Parameters"
      query_hash = request_params_to_search_hash(query_hash)
    end
    @search_class = search_class
    query_hash = filter_only_available(query_hash)
    if query_hash[:query] and query_hash[:query][:string].to_s.length > 0
      search_result = search_in_text(query_hash[:query][:string]).where(filter_hash_to_where_string(query_hash[:filter]))
      search_result = search_result + search_in_product_categories(query_hash[:query][:string])
      search_result = (search_result + search_in_dynamic_attributes(query_hash[:query][:string])).uniq
      search_result = filter_through_dynamic_attributes(search_result, query_hash[:filter]) if query_hash[:filter].length > 0
    elsif query_hash[:filter].length > 0
      search_result = self.products.where(filter_hash_to_where_string(query_hash[:filter]))
      search_result = filter_through_dynamic_attributes(search_result, query_hash[:filter])
    else
      search_result = self.products
    end
    return search_result.select{ |product| product }
  end

  def request_params_to_search_hash(params)
    search_and_filter_string = ""
    product = search_class.new
    product.website = website_relation
    params.each do |key, value|
      if product.has? key
        search_and_filter_string += ("#{key}__#{value}__")
      elsif key.to_s == "query_string"
        search_and_filter_string += ("query_string__#{value}__")
      end
    end
    return tokenizer(search_and_filter_string)
  end

  # This helper will remove all keys in the :filter sub hash that doesn't exist
  # in the provided models (or hashes) attributes or dynamic attributes (if such
  # exist)...
  def filter_only_available(query_hash)
    model_instance = search_class.new
    model_instance.website = website_relation
    cloned_hash = Marshal.load(Marshal.dump(query_hash))
    if cloned_hash[:filter]
      cloned_hash[:filter].each_key do |key|
        unless model_instance.has? key
          cloned_hash[:filter].delete(key)
        end
      end
    end
    cloned_hash
  end

  def filter_hash_to_where_string(h)
  	a = []
  	h.each_pair do |k,v|
  		# If it's a real attribute
  		if @search_class.attribute_names.include? k.to_s
	  		s = "`#{@search_class.table_name}`.`#{k.to_s}` "
	  		if v.class == Range
	  			# Detect infinity
	  			if (v.begin+v.end).abs == Float::INFINITY
	  				if v.begin.abs == Float::INFINITY and v.end.abs == Float::INFINITY
	  					s += "NOT NULL"
	  				elsif v.max == Float::INFINITY
	  					s += "> #{v.min.to_f}"
	  				elsif v.min == -Float::INFINITY
	  					s += "< #{v.max.to_f}"
	  				end
	  			else
	  				s += "BETWEEN #{v.begin.to_f} AND #{v.end.to_f}"
	  			end
	  		else
	  			# And default to letting Arel construct the query for us ...
	  			s = @search_class.where({k => v}).to_sql.match(/.*\ WHERE\ \((.*)\).*/)[1]
	  		end
	  		a << s
	  		h.delete(k)
	  	end
  	end
  	return a.join(' AND ')
  end

  def free_text_search(search_string)
    # Split the search into words
  	tokens = search_string.split.map{|t| "%#{t}%"}
    # Construct a search string per column to search in
		column_string =
      "(" + searchable_free_text_attributes
        .map{ |col| "LOWER(`#{search_class.table_name}`.`#{col}`) LIKE ?"  }
        .join(' OR ') + ")"

    # To change what kind of search is done alter this OR concatenation to an AND concatenation
    # Best way to do it is to add another variable under the 'query => {}' hash to include a 'op => "AND|OR"' alternative
    # Concat search strings per token in the search ...
    ["#{ ([column_string] * tokens.size).join(" OR ") }", *(tokens * searchable_free_text_attributes.size).sort]
  end

  def search_in_text(string)
    if searchable_free_text_attributes.size > 0
      self.products.where(free_text_search(string))
    else
      self.products.where('FALSE')
    end
  end

  def search_in_dynamic_attributes(string)
    unsearchable = unsearchable_attributes
    unsearchable = '' if unsearchable.empty?
    ids = website_relation
      .product_property_keys
      .where(data_type: 'string')
      .where('slug NOT IN (?)', unsearchable)
      .map(&:id)
    ProductPropertyValue
      .where(product_property_key_id: ids)
      .where('string LIKE ?', "%#{string}%")
      .map(&:product)
  end

  def search_in_product_categories(string)
    ProductCategory.where('title LIKE ?', "%#{string}%").map(&:products).flatten
  end

  def searchable_free_text_attributes
    search_free_text_columns - unsearchable_attributes
  end

  def unsearchable_attributes
    website_relation.filtered_attributes.select{ |k, v| v }.map{ |k, v| k }
  end

  def filter_through_dynamic_attributes(array, hash)
  	array.to_a.delete_if do |r|
      keep = true;
      hash.each do |k,v|
        if v.class == Range
          keep = (keep and v.cover? r.dynamic_attributes[k])
        else
          keep = (keep and r.dynamic_attributes[k] == v)
        end
      end
      !keep
    end
  end

  def has?(key)
    website_relation.filtered_attributes.has_key?(key.to_s) and !website_relation.filtered_attributes[key.to_s]
  end

  # If self is not a Website, get self.website, else get self.
  def website_relation
    self.respond_to?(:website) ? self.website : self
  end

end
