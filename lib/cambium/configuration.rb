module Cambium
  class Configuration

    attr_accessor :app_title,
                  :development_url,
                  :production_url

    def initialize
      @app_title            = 'Cambium'
      @development_url      = 'localhost:3000'
      @production_url       = 'example.com'
    end

  end

  # def self.configuration
  #   @configuration ||= Configuration.new
  # end

  # def self.configuration=(config)
  #   @configuration = config
  # end

  # def self.configure
  #   yield configuration
  # end
end
