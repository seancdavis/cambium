require 'cambium/version'
require 'cambium/configuration'

support_files = "#{File.expand_path('../cambium/support', __FILE__)}/*.rb"
Dir.glob(support_files).each do |file|
  require "cambium/support/#{File.basename(file)}"
end

module Cambium
  require 'cambium/engine' if defined?(Rails)
end
