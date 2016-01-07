# Cambium classes
require 'cambium/version'
require 'cambium/configuration'

# Gem to load by default (in case they are removed from
# Gemfile)
require 'bones-rails'
require 'kaminari'
require 'mark_it_zero'
require 'paper_trail'
require 'pg_search'
require 'pickadate-rails'
require 'superslug'
require 'trumbowyg_rails'

# Temp (hopefully) monkeypatch solution for Kaminari
require 'kaminari/helpers/tag'

module Cambium
  require 'cambium/engine' if defined?(Rails)
end
