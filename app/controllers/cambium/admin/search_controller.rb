module Cambium
  class Admin::SearchController < AdminController

    def index
      @collection = PgSearch.multisearch(params[:q]).includes(:searchable)
    end

  end
end