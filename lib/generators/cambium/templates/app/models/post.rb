class Post < ActiveRecord::Base

  # --------------------------------- plugins

  include Publishable, Slug, Tags
  # include PgSearch
  # multisearchable :against => [:title, :body], :using => :tsearch
  mount_uploader :main_image, ImageUploader
  paginates_per 10

  # --------------------------------- associations

  belongs_to :user

  # --------------------------------- validations

  validates :title, :presence => true

  # --------------------------------- scopes

  default_scope { order(:active_at => :desc) }
  scope :featured, -> { where(:is_featured => true) }
  scope :during, ->(year, month) { where(
    :active_at => "#{year}-#{month}-1".to_date..."#{year}-#{month}-1".to_date+1.month
  ) }

  # --------------------------------- instance methods

  def to_s
    self.title
  end

  def author
    self.user
  end

  def author_name
    author.full_name if author.present?
  end

  def summary_text
    "#{title} - #{active_at}, #{author.name}"
  end

end
