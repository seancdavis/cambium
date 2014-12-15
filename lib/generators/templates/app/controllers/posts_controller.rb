class PostsController < ApplicationController

  def index
  end

  def show
    @post = Post.find_by_slug(params[:slug])
    raise ActionController::RoutingError.new('Not Found') unless @post.present?
  end

end
