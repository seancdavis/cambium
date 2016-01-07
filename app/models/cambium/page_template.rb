module Cambium
  class PageTemplate

    def initialize(attrs)
      attributes(attrs)
      self
    end

    def attributes(attrs = nil)
      @attributes ||= begin
        name = attrs['file_path'].split('/').last.split('.').first
        attrs.merge('name' => name).stringify_keys
      end
    end

    def method_missing(method, *arguments, &block)
      respond_to?(method.to_s) ?  attributes[method.to_s] : super
    end

    def respond_to?(method, include_private = false)
      attributes.keys.include?(method.to_s)
    end

    def self.all
      load_objects
    end

    def self.find(name)
      cambium_template_names
    end

    private


      def self.cambium_templates
        Dir.glob("#{Cambium::Engine.root}/app/views/pages/*.html*")
      end

      def self.app_templates
        Dir.glob("#{Rails.root}/app/views/pages/*.html*")
      end

      def self.template_files
        (cambium_templates + app_templates).flatten.uniq
      end

      def self.load_objects
        objects = []
        yaml_regex = /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
        template_files.each do |file|
          content = File.read(file)
          if content =~ yaml_regex
            content = content.sub(yaml_regex, "")
            begin
              attrs = YAML.load($1).merge('file_path' => file)
              objects << PageTemplate.new(attrs)
            rescue => e
              Rails.logger.error "YAML Exception: #{e.message}"
              return []
            end
          end
        end
        objects
      end

  end
end
