require "cambium/version"

module Cambium

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :say_hello

    def initialize
      @say_hello = 'cheers'
    end
  end

end
