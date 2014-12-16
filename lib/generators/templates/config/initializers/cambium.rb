Cambium.configure do |config|

  # -------------------------------------------------- App Info

  # Cambium uses these to set your root urls for 
  # mailers and other fun stuff.
  # 
  config.development_url = 'localhost:3000'
  config.production_url = 'example.com'

  # The title of your app is what Cambium puts in the 
  # browser tab by default.
  # 
  config.app_title = 'Cambium'

  # -------------------------------------------------- Assets

  # The asset helpers define what Cambium will add to 
  # your Gemfile. They also tell Cambium which 
  # frameworks to install and configure.
  # 
  # NOTE: Only those listed below are available at this 
  # time. All others should be added to your Gemfile 
  # and configured manuallly.
  # 
  config.stylesheets_helpers = [:compass, :bones]
  config.javascripts_helpers = [:backbone]

  # -------------------------------------------------- Uploader

  # This is the gem to use to capture file uploads. 
  # It helps Cambium build you Gemfile, and it tells 
  # Cambium which config file to generate
  # 
  # Options: [:dragonfly, :carrierwave]
  # 
  config.uploader = :dragonfly

end
