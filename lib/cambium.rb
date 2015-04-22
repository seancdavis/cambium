# Cambium classes
require 'cambium/version'
require 'cambium/configuration'

# Gem to load by default (in case they are removed from
# Gemfile)
require 'kaminari'
require 'paper_trail'
require 'pg_search'
require 'pickadate-rails'
require 'superslug'

module Cambium
  require 'cambium/engine' if defined?(Rails)
end
