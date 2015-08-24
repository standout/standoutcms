class AttachmentFile < Asset
  has_attached_file :data,
	                  :s3_credentials => {
                      :access_key_id => ENV['ACCESS_KEY_ID'],
                      :secret_access_key => ENV['SECRET_ACCESS_KEY']},
	                  :storage => :s3,
                    :bucket => ENV['S3_BUCKET'],
                    :path => "files/:id/:style/:slug"

  validates_attachment_size :data, :less_than => 40.megabytes

  def slug
    if self.created_at && self.created_at <= Date.parse("2011-08-09")
      self.data_file_name
    else
      self.data_file_name.nil? ? '/images/missing.png' : self.data_file_name.to_slug
    end
  end

  def title
    self[:title].to_s != "" ? self[:title] : self.data_file_name
  end

  def to_liquid
    {
      name: title,
      url: url
    }
  end

end

Paperclip.interpolates :slug  do |attachment, style|
  attachment.instance.slug
end
