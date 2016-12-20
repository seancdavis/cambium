require 'rake'
require 'rails/generators'

module Cambium
  class Generator < Rails::Generators::Base

    private

      def self.templates_dir
        File.expand_path('../../generators/templates', __FILE__)
      end

  end
end
