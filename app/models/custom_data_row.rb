class CustomDataRow < ActiveRecord::Base
  serialize :json
  serialize :cached_liquid

  belongs_to :custom_data_list, :foreign_key => :custom_data_id

  has_many :pictures, :dependent => :destroy
  has_many :attachment_files, :dependent => :destroy
  accepts_nested_attributes_for :pictures, :allow_destroy => true

  before_save :fix_slug
  after_save :reserve_url

  def as_json(opts = {})
    json
      .merge(make_json_representation(attachment_files))
      .merge(make_json_representation(pictures))
      .merge(id: id)
      .merge(url: url)
      .merge(slug: slug)
  end

  # For backwards compliance
  def to_liquid
    {}
  end

  def website
    custom_data_list.website
  end

  # Kept for backwards compliance for a while
  def url
    "#{website.url}/#{slug}"
  end

  # Make sure that we have a slug/url that is unique and valid,
  # and don't allow empty slugs.
  def fix_slug
    if self.slug.blank?
      self.slug = self.slug_suggestion
    end
  end

  # The URL needs to be reserved in the global namespace.
  # TODO: ability to change /products/ to something user defined.
  def reserve_url
    if self.slug && self.slug_changed?
      UrlPointer.create(:website_id => self.website.id, :path => "/" + self.slug.to_s, :language => self.website.default_language, :custom_data_row_id => self.id)
    end
  end

  def make_json_representation(collection)
    Hash[*
      collection
        .map{ |item| [item.custom_data_field.slug.to_sym, item.url] }
        .flatten
    ]
  end

  def complete_html(current_member)
    self.custom_data_list.page.complete_html(current_member, self.language, { "item" => self })
  end

  def page
    custom_data_list.page if custom_data_list
  end

  # Return which language this row is set in. Defaults to the website default language if no field refers to language settings.
  def language
    @language ||= self.languages.last
  end

  def languages
    @languages ||= [self.custom_data_list.website.default_language] + self.fields.collect{ |f| f.fieldtype == 'language' ? self.json[f.name_to_slug.to_sym] : nil }.compact
  end

  def directory
    "custom_data_files/#{self.custom_data_id}"
  end

	def cms_title
		index = self.fields.collect(&:fieldtype).index('title')
		(index ? self.json[fields[index].name_to_slug.to_sym] : self.first_string_field_value.titleize)
	end

  # Come up with a unique but good-enough url structure if the user left it blank for some reason.
  def slug_suggestion
    "#{self.custom_data_list.liquid_name}/#{self.language}/#{self.first_string_field_value}"
  end

  def first_string_field_value
    self.json[self.fields.collect{ |f| f.fieldtype == 'string' || f.fieldtype == 'title' ? f.name.to_slug : nil }.compact.first.to_sym].to_slug
  rescue
    "#{self.custom_data_list.liquid_name.singularize}"
  end

  def first_string_field_name
    self.json[self.fields.collect{ |f| f.fieldtype == 'string' || f.fieldtype == 'title' ? f.name.to_slug : nil }.compact.first.to_sym]
  rescue
    "Unknown"
  end

  def images_for(field)
    @stored_images_for ||= {}
    @stored_images_for["#{field}"] ||= generate_images_for(field)
  end

  def generate_images_for(field)
    self.pictures.where(custom_data_field_id: field.id)
  end

  def files_for(field)
    @stored_files_for ||= {}
    @stored_files_for["#{field}"] ||= generate_files_for(field)
  end

  def files_for_data(field)
    files_for(field).collect{ |f| { "title" => f.title, "name" => f.data_file_name, "url" => f.url, "type" => f.content_type } }
  end

  def generate_files_for(field)
    self.attachment_files.where(custom_data_field_id: field.id)
  end

  def fields
    self.custom_data_list.nil? ? [] : self.custom_data_list.cached_custom_data_fields
  end

  def field_names
    @field_names ||= self.fields.collect(&:name_to_slug)
  end

  # We need to override respond_to? to be able to mass assign attributes
  # http://coderrr.wordpress.com/2008/07/11/solving-the-method_missing-respond_to-problem/
   alias_method :old_method_missing, :method_missing
    def method_missing m, *a, &b
      l = method_missing_proc m, *a, &b
      return l.call  if l

      old_method_missing m, *a, &b
    end

    alias_method :old_respond_to?, :respond_to?
    def respond_to?(m, include_priv = false)
      old_respond_to?(m) || !!method_missing_proc(m.to_sym)
    end

  # If we don't get a hit
   def respond_to_missing?(method, *args)
     if (method.to_s =~ /^(.*)_before_type_cast$/)
       send $1
     else
       self.field_names.include?(method.to_s.match(/^(.*)=$/)[1].to_s) rescue false
     end
   end

   alias_method :old_method, :method
   def method m
     old_method m
   rescue NameError
     l = method_missing_proc m
     (class<<self;self;end).class_eval { define_method m, &l }
     retry
   end

  def method_missing_proc *a; nil; end
  alias_method :old_method, :method

  # Define our methods for the json variable on the fly depending on which data fields are added to the custom data model.
  def method_missing(method, *args)
    if (method.to_s =~ /^(.*)_before_type_cast$/)
      send $1
    elsif method.to_s =~ /=$/
      if self.fields.collect(&:name_to_slug).include?(method.to_s.gsub('=', '').gsub('.', ''))
        self.json = {} if self.json.nil?
        self.json.to_hash[method.to_s.match(/^(.*)=$/)[1].to_sym] = args.first
      else
        # puts "Could not find method #{method.to_s.gsub('=', '').gsub('.', '')}"
        super
      end
    else
      if self.fields.collect(&:name_to_slug).include?(method.to_s)
        self.json.nil? ? nil : self.json[method.to_s.to_sym]
      else
        super
      end
    end
  end

end
