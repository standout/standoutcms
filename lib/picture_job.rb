class PictureJob < Struct.new(:picture_id)
  def perform
    Picture.find(self.picture_id).perform
  end
end