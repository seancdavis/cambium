module Cambium
  class Configuration

    attr_accessor \
      :development_url,
      :production_url,
      :app_title,
      :stylesheets_helpers,
      :javascripts_helpers,
      :uploader,

    def initialize
      @development_url      = 'localhost:3000'
      @production_url       = 'example.com'
      @app_title            = 'Cambium'
      @stylesheets_helpers  = [:compass, :bones]
      @javascripts_helpers  = [:backbone]
      @uploader             = :dragonfly
    end

  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
