module Publishable
  extend ActiveSupport::Concern

  included do

    # --------------------------------- Attributes

    attr_accessor :active, :active_date, :active_time, :inactive_date, 
      :inactive_time

    # --------------------------------- Scopes

    scope :published, -> { where("(active_at <= ? AND inactive_at > ?) OR 
                                (active_at <= ? AND inactive_at IS ?)",
                                Time.now, Time.now, Time.now, nil) }
    scope :unpublished, -> { where("active_at > ? OR inactive_at < ? OR 
                                (active_at IS ? AND inactive_at IS ?)",
                                Time.now, Time.now, nil, nil) }

    # --------------------------------- Callbacks

    before_save :convert_dates

  end

  # --------------------------------- Instance Methods

  def published?
    return false if active_at.nil?
    (active_at <= Time.now and inactive_at == nil) or
      (active_at <= Time.now and inactive_at >= Time.now)
  end

  def formatted_active_date
    formatted_date(active_at)
  end

  def formatted_inactive_date
    formatted_date(inactive_at)
  end

  def formatted_date(date)
    return '' if date.nil?
    date.strftime("%d %B, %Y")
  end

  def formatted_active_time
    return '' if active_at.nil?
    active_at.strftime("%l:%M %p")
  end

  def formatted_inactive_time
    return '' if inactive_at.nil?
    inactive_at.strftime("%l:%M %p")
  end

  def convert_dates
    self.active_time = Time.now.strftime("%l:%M %p") if self.active_time.blank?
    self.inactive_time = '12:00 AM' if self.inactive_time.blank?
    if self.active_date.blank?
      self.active_at = nil
    else
      self.active_at = DateTime.strptime("#{self.active_date} 
        #{self.active_time}", "%d %B, %Y %l:%M %p")
    end
    if self.inactive_date.blank?
      self.inactive_at = nil
    else
      self.inactive_at = DateTime.strptime("#{self.inactive_date} 
        #{self.inactive_time}", "%d %B, %Y %l:%M %p")
    end
  end

  def publish!
    update_column :active_at, Time.now
  end

end
