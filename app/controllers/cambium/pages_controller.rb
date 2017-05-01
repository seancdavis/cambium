class Cambium::PagesController < ApplicationController

  before_action :set_page, :only => [:show]
  before_action :set_home_page, :only => [:home]

  if Cambium.configuration.cache_pages
    caches_action :show, :cache_path => :page_cache_path.to_proc
    caches_action :home, :cache_path => :page_cache_path.to_proc
  end

  def show
    render :inline => @page.template.content, :layout => 'application'
  end

  def home
    if @page.nil?
      render 'home_missing'
    else
      render :inline => @page.template.content, :layout => 'application'
    end
  end

  protected

    def set_page
      @page = Cambium::Page.find_by_page_path(request.path)
    end

    def set_home_page
      @page = Cambium::Page.home
    end

    def q_to_s
      request.query_parameters.to_a.collect { |q| "_#{q[0]}_#{q[1]}"  }.join('')
    end

    def page_cache_path
      "_p#{@page.id}#{q_to_s}"
    end

end
