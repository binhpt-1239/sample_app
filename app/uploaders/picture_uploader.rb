class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_limit: [Settings.digit_400, Settings.digit_400]

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    Settings.format_picture
  end
end
