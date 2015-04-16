module Cambium
  class Admin::SearchController < AdminController

    def index
      @collection = PgSearch.multisearch(params[:q])
    end

  end
end