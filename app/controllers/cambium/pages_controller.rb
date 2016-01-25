class Cambium::PagesController < ApplicationController

  def show
    @page = Cambium::Page.find_by_page_path(request.path)
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
