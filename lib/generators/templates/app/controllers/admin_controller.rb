class AdminController < ActionController::Base

  include AdminHelper

  before_filter :authenticate_admin
  before_action :set_defaults, :except => [:dashboard]
  before_action :set_routes, :except => [:dashboard]
  protect_from_forgery :with => :exception

  def dashboard
    redirect_to admin_users_path
  end

  def index
    @items = @model.all
  end

  def new
    @item = @model.new
    @url = @routes[:index]
  end

  def edit
    @url = @routes[:show]
  end

  def create
    @item = @model.new(create_params)
    convert_dates if @item.attributes.has_key?('active_at')
    @item = @model.new(create_params)
    if @item.attributes.has_key? 'slug' && !create_params[:slug].blank?
      @item.slug = @item.make_slug_unique(create_params[:slug])
    end
    if @item.save
      @routes[:edit] = send("edit_admin_#{model_table_singular}_path", @item)
      redirect_to @routes[:edit], :notice => "#{@model.to_s} was successfully created."
    else
      @url = @routes[:index]
      render :action => "new"
    end
  end

  def update
    convert_dates if @item.attributes.has_key?('active_at')
    if @item.attributes.has_key? 'slug' && !update_params[:slug].blank?
      update_params[:slug] = @item.make_slug_unique(update_params[:slug])
    end
    if @item.update(update_params)
      @routes[:edit] = send("edit_admin_#{model_table_singular}_path", @item)
      redirect_to @routes[:edit], :notice => "#{@model.to_s} was updated successfully."
    else
      @url = @routes[:show]
      render :action => "edit"
    end
  end

  def destroy
    @item.destroy
    redirect_to @routes[:index], :notice => "#{@model.to_s} was deleted successfully."
  end

  private

    def authenticate_admin
      authenticate_user!
      redirect_to root_path unless current_user.is_admin?
    end

    def set_defaults
      @columns = ['title']
      @actions = [:edit, :delete]
    end

    def convert_dates
      p = params[@model.to_s.downcase.to_sym]
      p[:active_time] = Time.now.strftime("%l:%M %p") if p[:active_date].blank?
      p[:inactive_time] = '12:00 AM' if p[:active_time].blank?
      if p[:active_date].blank?
        p[:active_at] = nil
      else
        p[:active_at] = DateTime.parse("#{p[:active_date]} #{p[:active_time]}")
      end
      if p[:inactive_date].blank?
        p[:inactive_at] = nil
      else
        p[:inactive_at] = DateTime.parse("#{p[:inactive_date]} #{p[:inactive_time]}")
      end
    end

    def create_params
    end

    def update_params
      create_params
    end

end
