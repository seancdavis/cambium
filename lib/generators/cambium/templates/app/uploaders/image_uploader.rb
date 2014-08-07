# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  include CarrierWave::MimeTypes

  # This is our standard storage method, which stores the files to the file
  # system. In some cases, you might need to upload to a remote server. In that
  # case, we recommend using CarrierWave Direct:
  # 
  #     https://github.com/dwilkie/carrierwave_direct
  # 
  storage :file

  # This is the path at which your images will be stored. This is different than
  # the default, but keeps the path to images nice and clean. Feel free to
  # change to your liking.
  # 
  def store_dir
    "media/images/#{model.id}"
  end

  # These are the "versions" created when a new image is uploaded. You can
  # change these to meet your preferences, noting the comments below.
  # 
  # For example, if the version is "thumb," you'll be able to get the image by
  # calling something like this:
  # 
  #     image = Image.find(1)
  #     image.filename.thumb.url OR image.filename.url(:thumb)
  # 
  version :thumb do
    # 
    # resize_to_fill will automatically crop the image (to the middle),
    # resulting in an image of the dimensions you pass.
    # 
    process :resize_to_fill => [150,150]
  end

  version :tile do
    # 
    # If you want to override the manual crop (with the cropping tool), you need
    # to call this method (process :crop) before you process the resizing.
    # 
    process :crop
    process :resize_to_fill => [240,180]
  end

  # This is the version we use for cropping. You need to ensure:
  # 
  # 1. the process method is passing ":resize_to_limit" and NOT
  #    ":resize_to_fill"
  # 
  # 2. the dimensions are taller and wider than your version that calls 
  #    "process :crop"
  # 
  version :to_crop do
    process :resize_to_limit => [500,500]
  end

  # If you wish to limit the file extensions, edit this list as necessary
  # 
  # If, instead, you don't care about the file extension (although you should,
  # since the is an "image" uploader), you can delete this method.
  # 
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # This method is physically preparing the method for manual cropping.
  # 
  # MAKE SURE your "resize_to_limit" call here passes the dimensions IDENTICAL
  # TO YOUR :crop VERSION
  # 
  # Other than that, you can leave this method alone.
  # 
  def crop
    if model.crop_x.present?
      resize_to_limit(500,500)
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop!(x, y, w, h)
      end
    end
  end

end
