class Admin::TagsController < ApplicationController

  def index
    @tags = Tag.all
    respond_to do |format|
      format.json { render :json => @tags }
    end
  end


end
