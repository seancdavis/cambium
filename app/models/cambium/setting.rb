module Cambium
  class Setting < ActiveRecord::Base

    # ------------------------------------------ Plugins

    include PgSearch

    multisearchable :against => [:key, :value]
    has_paper_trail

    # ------------------------------------------ Validations

    validates :key, :presence => true, :uniqueness => true

    # ------------------------------------------ Scopes

    scope :alpha, -> { order(:key => :asc) }

    # ------------------------------------------ Class Methods

    def self.keys
      all.collect(&:key)
    end

    # ------------------------------------------ Instance Methods

    def to_s
      key
    end

  end
end
