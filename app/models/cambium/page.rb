module Cambium
  class Page < ActiveRecord::Base

    # ------------------------------------------ Plugins

    include PgSearch

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

  end
end
