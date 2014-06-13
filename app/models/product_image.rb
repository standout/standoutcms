class ProductImage < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_category
  acts_as_list scope: [:product_id, :product_category_id]
  has_attached_file :image,
    styles: { small: "100x100>", medium: "400x300>", large: "800x600>" },
    processors: [:cropper],
    path: ":rails_root/public/system/images/:id/:style/:filename",
    url: "/system/images/:id/:style/:filename"
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_image, :if => :cropping?

  def to_liquid
    { "small" => image.url(:small), "medium" => image.url(:medium), "large" => image.url(:large) }
  end

  def relative_parent
    product or product_category
  end

  def url(style = :original)
    'http://' + relative_parent.website.domain.to_s + image.url(style).to_s
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def image_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
  end

  private
  def reprocess_image
    image.reprocess!
  end

end
