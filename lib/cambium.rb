# Cambium classes
require 'cambium/version'
require 'cambium/configuration'
require 'cambium/generator'

module Cambium
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
