require 'rake'
require 'rails/generators'

module Cambium
  class Generator < Rails::Generators::Base

    private

      def self.templates_dir
        File.expand_path('../../generators/templates', __FILE__)
      end

      def template_file_path(path)
        "#{Cambium::Generator.templates_dir}/#{path}"
      end

      def read_file(path)
        File.read(template_file_path(path))
      end

  end
end
