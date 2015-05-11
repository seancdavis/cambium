class Cambium::Admin::SearchController < Cambium::AdminController

  def index
    @collection = PgSearch.multisearch(params[:q]).includes(:searchable)
  end

end
