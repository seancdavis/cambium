require 'yaml'

class Page < ActiveRecord::Base

  # --------------------------------- plugins

  include Publishable, Slug
  # multisearchable :against => [:title, :body, :description], :using => :tsearch
  has_ancestry

  # --------------------------------- Associations

  # belongs_to :user, :as => :author

  # --------------------------------- Callbacks

  # --------------------------------- Validations

  validates :title, :presence => true

  # --------------------------------- Scopes

  default_scope { order('ancestry DESC, position ASC') }
  scope :for_nav, -> { where(:in_nav => true) }

  # --------------------------------- instance methods

  def parent_options
    if id.present?
      Page.unscoped.where('id != ?', id).order(:title)
    else
      Page.all.unscoped.order(:title)
    end
  end

  def to_s
    title
  end

  def ancestral_title
    ancestors.collect(&:title).push(title).join(' : ')
  end

  def template_name
    template.humanize
  end

  def template_value(field_name)
    if template_data.present? && template_data.has_key?(field_name.to_s)
      template_data[field_name.to_s]
    end
  end

  def template_fields
    template_file = "#{Rails.Application.config.template_directory}/#{self.template}.yml"
    if File.exists?(template_file)
      template_yaml = YAML.load_file(template_file)
      template_yaml['fields']
    end
  end

  def has_nav_children?
    children.for_nav.published.count > 0
  end

  # --------------------------------- class methods

  def self.options_for_select
    Page.unscoped.published.order(:title).collect do |p|
      [p.title, "/#{p.slug}"]
    end
  end

end