module Cambium
  class Page < ActiveRecord::Base

    # ------------------------------------------ Plugins

    include PgSearch, Publishable

    multisearchable :against => [:title]
    has_paper_trail
    has_superslug
    has_ancestry

    # ------------------------------------------ Validations

    validates :title, :presence => true

    # ------------------------------------------ Scopes

    scope :alpha, -> { order(:title => :asc) }

    # ------------------------------------------ Callbacks

    after_save :cache_page_path
    after_save :reload_routes!

    # ------------------------------------------ Class Methods

    def self.home
      where(:is_home => true).published.first
    end

    # ------------------------------------------ Instance Methods

    def to_s
      title
    end

    def template
      PageTemplate.find(template_name)
    end

    def body
      html.html_safe
    end

    def path_preview
      "<a href='#{page_path}' target='_blank'>#{page_path}</a>".html_safe
    end

    def method_missing(method, *arguments, &block)
      if respond_to?(method.to_s)
        if template.fields[method.to_s]['type'] == 'media'
          Cambium::Document.find_by_id(template_data[method.to_s].to_i)
        else
          template_data[method.to_s]
        end
      else
        super
      end
    end

    def respond_to?(method, include_private = false)
      return true if super
      return false if template.blank?
      return true if template.fields.keys.include?(method.to_s)
      false
    end

    private

      def reload_routes!
        Rails.application.reload_routes!
      end

      def cache_page_path
        update_columns(:page_path => "/#{path.collect(&:slug).join('/')}")
      end

  end
end
