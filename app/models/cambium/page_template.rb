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

    def has_fields?
      respond_to?('fields')
    end

    def method_missing(method, *arguments, &block)
      respond_to?(method.to_s) ?  attributes[method.to_s] : super
    end

    def respond_to?(method, include_private = false)
      attributes.keys.include?(method.to_s)
    end

    def self.all
      (app_templates + cambium_templates).flatten.sort_by(&:name)
    end

    def self.names
      all.collect(&:name).flatten.uniq.sort
    end

    def self.find(name)
      all.select { |t| t.name == name }.first
    end

    private

      def self.cambium_template_files
        Dir.glob("#{Cambium::Engine.root}/app/views/pages/*.html*")
      end

      def self.cambium_templates
        templates = []
        cambium_template_files.each do |f|
          templates << create_from_file(f, :cambium)
        end
        templates.reject { |t| app_templates.collect(&:name).include?(t.name) }
      end

      def self.app_template_files
        Dir.glob("#{Rails.root}/app/views/pages/*.html*")
      end

      def self.app_templates
        templates = []
        app_template_files.each do |f|
          templates << create_from_file(f, :app)
        end
        templates
      end

      def self.create_from_file(file, type)
        yaml_regex = /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
        content = File.read(file)
        if content =~ yaml_regex
          content = content.sub(yaml_regex, "")
          begin
            attrs = YAML.load($1).merge('file_path' => file, 'type' => type)
            return PageTemplate.new(attrs)
          rescue => e
            Rails.logger.error "YAML Exception: #{e.message}"
            return nil
          end
        end
      end

  end
end
