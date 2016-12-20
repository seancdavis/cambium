Cambium.configure do |config|

  # -------------------------------------------------- App Info

  # Cambium uses these to set your root urls for mailers and other fun stuff.
  config.development_url = 'localhost:3000'
  config.production_url = 'example.com'

  # The title of your app is what Cambium puts in the browser tab by default.
  config.app_title = '<%= Rails.application.class.parent_name %>'

end
