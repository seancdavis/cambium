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

    def self.method_missing(method, *arguments, &block)
      super
    rescue
      setting = self.find_by_key(method.to_s)
      return setting.value unless setting.nil?
      super
    end

    # ------------------------------------------ Instance Methods

    def to_s
      key
    end

  end
end
