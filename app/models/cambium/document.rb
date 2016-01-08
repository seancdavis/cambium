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

    def image?
      ['jpg','jpeg','gif','png'].include?(upload.ext.downcase)
    end

    def pdf?
      upload.ext.downcase == 'pdf'
    end

    def has_thumb?
      thumb_url.present?
    end

    def thumb_url
      return upload.thumb('300x300#').url if image?
      return upload.thumb('300x300#', :format => 'png', :frame => 0).url if pdf?
      nil
    end

    def ext
      upload.ext
    end

  end
end
