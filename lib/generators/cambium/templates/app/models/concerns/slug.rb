module Slug
  extend ActiveSupport::Concern

  included do
    after_save :sluggify_slug

    def self.find(input)
      input.to_i == 0 ? find_by_slug(input) : super
    end
  end

  def sluggify_slug
    if slug.blank?
      update_column(:slug, create_slug)
    else
      new_slug = slug.gsub(/[^a-zA-Z0-9 \-]/, "") # remove all bad characters
      new_slug.gsub!(/\ /, "-") # replace spaces with underscores
      new_slug.gsub!(/\-+/, "-") # replace repeating underscores
      update_column(:slug, new_slug) unless slug == new_slug
    end
  end

  def create_slug
    slug = self.title.downcase.gsub(/\&/, ' and ') # & -> and
    slug.gsub!(/[^a-zA-Z0-9 \-]/, "") # remove all bad characters
    slug.gsub!(/\ /, "-") # replace spaces with underscores
    slug.gsub!(/\-+/, "-") # replace repeating underscores

    dups = self.class.name.constantize.where(:slug => slug)
    if dups.count == 1 and dups.first != self
      if self.idx.present?
        slug = "#{slug}-#{self.idx}"
      else
        slug = "#{slug}-#{self.id}"
      end
    end
    slug
  end

  def make_slug_unique(slug)
    dups = self.class.name.constantize.where(:slug => slug)
    if dups.count == 1 and dups.first != self
      if self.idx.present?
        slug = "#{slug}-#{self.idx}"
      else
        slug = "#{slug}-#{self.id}"
      end
    end
    slug
  end

  def to_param
    slug
  end

end
