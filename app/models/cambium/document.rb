module Cambium
  class Document < ActiveRecord::Base

    # ------------------------------------------ Plugins

    include PgSearch

    multisearchable :against => [:title]
    has_paper_trail

    # ------------------------------------------ Plugins

    dragonfly_accessor :image

    # ------------------------------------------ Instance Methods

    def to_s
      title
    end

  end
end
