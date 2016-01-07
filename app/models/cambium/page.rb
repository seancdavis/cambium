module Cambium
  class Page < ActiveRecord::Base

    # ------------------------------------------ Plugins

    include PgSearch, Publishable

    multisearchable :against => [:title]
    has_paper_trail
    has_superslug

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

    def method_missing(method, *arguments, &block)
      respond_to?(method.to_s) ?  template_data[method.to_s] : super
    end

    def respond_to?(method, include_private = false)
      return true if template_data.keys.include?(method.to_s)
      super
    end

  end
end
