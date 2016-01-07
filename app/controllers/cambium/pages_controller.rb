class Cambium::PagesController < Cambium::BaseController

  def show
    slug = request.path.split('/').last
    @page = Cambium::Page.find_by_slug(slug)
    render :inline => @page.template.content
  end

end
