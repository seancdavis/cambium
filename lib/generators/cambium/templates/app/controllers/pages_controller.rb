class PagesController < ApplicationController

  def show
    @page = Page.find_by_slug(params[:slug]) if @page.nil?
    if @page
      render "#{Rails.applcation.config.template_directory}/#{@page.template}"
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end