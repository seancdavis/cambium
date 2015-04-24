module Cambium
  class Configuration

    attr_accessor \
      :development_url,
      :production_url,
      :app_title,

    def initialize
      @development_url      = 'localhost:3000'
      @production_url       = 'example.com'
      @app_title            = 'Cambium'
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
