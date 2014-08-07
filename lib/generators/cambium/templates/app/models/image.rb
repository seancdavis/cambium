class Image < ActiveRecord::Base

  # ------------------------------------------ Plugins

  # As you might suspect, this concern (app/models/concerns/image_cropper.rb)
  # add all the methods we need to control cropping our images manually. If you
  # aren't going to use that feature, just get rid of this line.
  # 
  include ImageCropper

  # ------------------------------------------ Uploaders

  # This is a carrierwave method that uses our ImageUploader
  # (app/uploaders/image_uploader.rb) to manage the uploading process and
  # creating versions
  # 
  mount_uploader :filename, ImageUploader

  # ------------------------------------------ Validations

  # Require a file to actually be present when we try to create a new record
  # 
  validates :filename, :presence => true

  # ------------------------------------------ Scopes

  # We don't like to use default scopes. But many times we'll reference a
  # listing of the images by the date they were creating.
  # 
  scope :recent, -> { order('created_at DESC') }

  # ------------------------------------------ Instance Methods

  # This helps up with jQuery uploading (doing it on the fly vs. reloading a
  # page).
  # 
  def to_jq_upload
    {
      "name" => read_attribute(:filename)
    }
  end

end
