module Cambium
  class Configuration

    attr_accessor \
      :stylesheets_helpers,
      :javascripts_helpers,
      :uploader

    def initialize
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
