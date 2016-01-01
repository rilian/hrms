# encoding: utf-8

class BaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::ImageOptimizer
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  storage :file

  def store_dir
    File.join ENV['UPLOADS_DIR'], "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    '/tmp'
  end

  process optimize: [{ quiet: true }]

  version :thumb do
    process resize_to_fit: [100, 100]
    process optimize: [{ quiet: true }]
  end
end
