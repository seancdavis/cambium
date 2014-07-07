module Tags
  extend ActiveSupport::Concern

  included do
    has_many :taggings, :as => :taggable
    has_many :tags, :through => :taggings

    attr_accessor :tag_list

    after_save :update_tags!
  end

  def update_tags!
    unless tag_list.nil?
      self.tags = []
      used_tags = []
      tag_list.split(',').each do |name|
        name.strip!
        if !used_tags.include?(name) && name.present?
          used_tags << name
          tag = Tag.find_or_create_by(:name => name)
          self.tags << tag
        end
      end
    end
  end

end
