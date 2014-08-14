# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  ci_name    :string(255)
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

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
