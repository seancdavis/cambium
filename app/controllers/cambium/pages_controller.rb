class Cambium::PagesController < ApplicationController

  def show
    slug = request.path.split('/').last
    @page = Cambium::Page.find_by_slug(slug)
    render :inline => @page.template.content, :layout => 'application'
  end

  def home
    @page = Cambium::Page.home
    if @page.nil?
      render 'home_missing'
    else
      render :inline => @page.template.content, :layout => 'application'
    end
  end

end
