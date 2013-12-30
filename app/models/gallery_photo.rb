class GalleryPhoto < ActiveRecord::Base
  
  attr_accessible :gallery_id, :photo, :caption
  belongs_to :gallery
  
  has_attached_file :photo, {
    :styles => lambda { |attachment|
                            { :thumb => attachment.instance.thumbnail_size,
                              :large => attachment.instance.large_size }
                          },
    :s3_credentials => {
      :access_key_id => ENV['ACCESS_KEY_ID'],
      :secret_access_key => ENV['SECRET_ACCESS_KEY']},
    :storage => :s3,
    :bucket => ENV['S3_BUCKET'],
    :path => "gallery/:id/:style/:slug" }

  def slug
    if self.created_at && self.created_at <= Date.parse("2011-08-09")
      self.photo_file_name
    else
      self.photo_file_name.nil? ? '/images/missing.png' : self.photo_file_name.to_slug
    end
  end
  
  def caption
    self[:caption].to_s == "" ? self.photo_file_name : self[:caption]
  end

  def thumbnail_size
    self.gallery.thumbnail_size
  end
  
  def large_size
    self.gallery.large_size
  end
  
  def to_liquid
    { "title" => self.caption,
      "thumb" => self.photo.url(:thumb).to_s, 
      "large" => self.photo.url(:large).to_s, 
      "original" => self.photo.url(:original).to_s }
  end
  
end

Paperclip.interpolates :slug  do |attachment, style|
  attachment.instance.slug
end