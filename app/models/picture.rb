require 'open-uri'
class Picture < Asset

  attr_accessor :image_url
  belongs_to :custom_data_field
  belongs_to :custom_data_row, :touch => true
  has_attached_file :data,
                  path: ":rails_root/public/system/data/:id/:style/:filename",
                  url: "/system/data/:id/:style/:filename",
                  :styles => lambda { |attachment|
                    {
                      :content => '500x500>',
                      :thumb => '100x100#',
                      :small => attachment.instance.small_style,
                      :medium => attachment.instance.medium_style,
                      :large => attachment.instance.large_style
                    }
                  }

	validates_attachment_size :data, :less_than => 20.megabytes
	before_validation :download_remote_image, :if => :image_url_provided?
  after_create :reprocess

  def slug
    if self.created_at && self.created_at <= Date.parse("2011-08-09")
      self.data_file_name
    else
      self.data_file_name.nil? ? '/assets/missing.png' : self.data_file_name.to_slug
    end
  end

	def small_style
	  if self.custom_data_field
	    self.custom_data_field.image_size_small
	  else
	    "200x200#"
	  end
	end

	def medium_style
	  if self.custom_data_field
	    self.custom_data_field.image_size_medium
	  else
	    "400x300"
	  end
	end

	def large_style
	  if self.custom_data_field
	    self.custom_data_field.image_size_large
	  else
	    "800x600"
	  end
	end

	def perform
	  begin
    self.processing = false # unlock for processing
    data.reprocess! # do the processing
    self.save!

    # Remove images if something goes wrong
    rescue => e
      logger.info "Error processing image #{self.id}. Retrying later ..."
      logger.info "#{e.inspect}"
    end
  end

  # trigged when custom data field image size is changed
  def reprocess
    self.update_attribute :processing, true
    Delayed::Job.enqueue PictureJob.new(id) # add to queue
  end

  def url(style = :original)
    if self.data && processing? && (style != :original && style != :thumb)
      return '/assets/missing.png?processing'
    end

    data.url(style).to_s
  end

  def self.process_all
    Picture.all(:conditions => ["processing = ?", true]).collect(&:perform)
  end

  private

  def image_url_provided?
    !self.image_url.blank?
  end

  def download_remote_image
    self.data = do_download_remote_image
  end

  def do_download_remote_image
    io = open(URI.parse(image_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue
     # TODO: nice error handling if image could not be found.
  end
end

Paperclip.interpolates :slug  do |attachment, style|
  attachment.instance.slug
end
