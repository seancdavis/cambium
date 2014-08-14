# == Schema Information
#
# Table name: taggings
#
#  id            :integer          not null, primary key
#  tag_id        :integer
#  taggable_id   :integer
#  taggable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Tagging < ActiveRecord::Base

  # ------------------------------------------ Associations

  belongs_to :tag
  belongs_to :taggable, :polymorphic => true

end
