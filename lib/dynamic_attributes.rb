module DynamicAttributes
  def dynamic_attribute_accessors
    keys = dynamic_attributes.keys
    keys + keys.map{ |key| :"#{key}=" }
  end

  def dynamic_attributes
    unless website
      Rails.logger.warn "module DynamicAttributes (#{__FILE__.slice(Rails.root.to_s.length..-1)}) on line #{__LINE__} : Variable 'website' is empty! Dynamic attributes are keyed per website, returning empty hash."
      return {}
    end

    values = product_property_values

    array = website.product_property_keys.map do |key|
      value = values.select{ |v| v.product_property_key_id == key.id }.first
      value = value.send(key.data_type) if value
      [key.slug.to_sym, value]
    end

    Hash[*array.flatten]
  end

  def update_dynamic_attribute(key, value)
    product_property_key =
      website.product_property_keys.where(slug: key.to_s).first
    product_property_value =
      product_property_values
        .where(product_property_key_id: product_property_key.id)
        .first

    if product_property_value
      product_property_value
        .update_attribute(product_property_key.data_type, value)
    else
      attrs = {product_property_key_id: product_property_key.id, product_id: id}
      attrs[product_property_key.data_type] = value
      product_property_values.create attrs rescue nil
    end
  end

  def update_dynamic_attributes(hash)
    hash = Hash[*hash.map{ |key, value| [key.to_s, value] }.flatten]

    website.product_property_keys.each do |key|
      key_name = key.slug
      next unless hash.has_key?(key_name)
      update_dynamic_attribute(key_name, hash[key_name])
    end
  end

  def method_missing(method, *args, &block)
    return super unless dynamic_attribute_accessors.include?(method)

    if method.to_s[-1] == '='
      update_dynamic_attribute(method.to_s[0...-1], args[0])
    else
      dynamic_attributes[method]
    end
  end
end
