class Asset < ActiveRecord::Base

  belongs_to :website
  belongs_to :assetable, :polymorphic => true
  belongs_to :custom_data_field
  belongs_to :product_category

  def url(*args)
    data.url(*args)
  end

  def filename
    data_file_name
  end

  def content_type
    data_content_type
  end

  def size
    data_file_size
  end

  def to_xml(options = {})
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])

    xml.tag!(self.type.to_s.downcase) do
      xml.filename{ xml.cdata!(self.filename) }
      xml.size self.size
      xml.path{ xml.cdata!(self.url) }

      xml.styles do
        self.styles.each do |style|
          xml.tag!(t.style, self.url(style))
        end
      end unless self.styles.empty?
    end

  end

end
