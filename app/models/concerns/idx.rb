module Idx
  extend ActiveSupport::Concern

  included do

    # ------------------------------------------ Scopes

    scope :by_idx, -> { reorder('idx asc') }

    # ------------------------------------------ Callbacks

    after_create :create_idx

  end

  # ------------------------------------------ Instance Methods

  def to_param
    idx.to_s
  end

  def create_idx
    last_obj = self.idx_class.send(self.class.table_name).by_idx.last
    idx = last_obj.idx + 1
    update_columns(:idx => idx)
  end

end
