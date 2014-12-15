Cambium.configure do |config|

  # -------------------------------------------------- Assets
  # 
  # The asset helpers define what Cambium will add to 
  # your Gemfile. They also tell Cambium which 
  # frameworks to install and configure.
  # 
  config.stylesheets_helpers = [:compass, :bones]
  config.javascripts_helpers = [:backbone]

  # -------------------------------------------------- Uploader
  # 
  # This is the gem to use to capture file uploads. 
  # It helps Cambium build you Gemfile, and it tells 
  # Cambium which config file to generate
  # 
  # Options: [:dragonfly, :carrierwave]
  # 
  config.uploader = :dragonfly

end
