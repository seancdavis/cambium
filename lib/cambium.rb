require 'cambium/version'
require 'cambium/configuration'

module Cambium
  require 'cambium/engine' if defined?(Rails)
end
