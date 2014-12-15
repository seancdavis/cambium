module ImageCropper
  extend ActiveSupport::Concern

  included do

    # We use these accessors to pass values to CarrierWave and RMagick without
    # needing to store them in the database.
    # 
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

    # Like the accessors, this is used for cropping images.
    # 
    after_update :crop_image
  end

  # This simply makes carrierwave and rmagick recreate all its versions. We only
  # call it if the `crop_x` attribute is present, as we use that as our trigger.
  # Otherwise, we're recreating versions without changing anything.
  # 
  def crop_image
    filename.recreate_versions! if crop_x.present?
  end

end
