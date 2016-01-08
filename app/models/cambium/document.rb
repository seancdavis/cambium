module Cambium
  class Document < ActiveRecord::Base

    # ------------------------------------------ Plugins

    include PgSearch

    multisearchable :against => [:title]
    has_paper_trail

    dragonfly_accessor :upload

    # ------------------------------------------ Validations

    validates :title, :upload, :presence => true

    # ------------------------------------------ Instance Methods

    def to_s
      title
    end

  end
end
