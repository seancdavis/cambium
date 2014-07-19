class Tag < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include Slug, Title

  # ------------------------------------------ Associations

  has_many :tag_assignments

  # ------------------------------------------ Callbacks

  before_save :downcase_name

  # ------------------------------------------ Instance Methods

  def downcase_name
    self.ci_name = self.name.downcase
  end

end
