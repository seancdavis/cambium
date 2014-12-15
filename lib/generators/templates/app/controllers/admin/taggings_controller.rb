class Admin::TaggingsController < ApplicationController
  before_filter :get_params

  def index
    respond_to do |format|
      format.json # { render json: @taggings }
    end
  end

  def edit
  end

  def create
    tags = Tag.where("lower(name) = ?", params[:tag_title].downcase)
    if tags.count > 0
      @tag = tags.first
    else
      @tag = Tag.create(name: params[:tag_title])
    end

    @taggable = params[:taggable].constantize.find(params[:taggable_id])
    logger.debug @taggable.inspect
    Tagging.where(tag_id: @tag.id, taggable_type: @taggable.class.name, taggable_id: @taggable.id).first_or_create
    render nothing: true
  end

  def update
    respond_to do |format|
      if @tagging.update_attributes(params[:tagging])
        format.json { head :no_content }
      else
        format.json { render json: @tagging.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tagging = Tagging.find(params[:id])
    @tagging.destroy
    render :nothing => true
  end

  private
  def get_params
    if params[:page_id]
      @page = Page.find(params[:page_id])
      @index = admin_page_taggings_path(@page)
      @taggings = @page.taggings
    elsif params[:post_id]
      @post = Post.find_by_slug(params[:post_id])
      @index = admin_post_taggings_path(@post)
      @taggings = @post.taggings
    elsif params[:image_id]
      @image = Image.find(params[:image_id])
      @project = Project.find(params[:project_id])
      @index = admin_project_image_taggings_path(@project,@image)
      @taggings = @image.taggings
    elsif params[:project_id]
      @project = Project.find(params[:project_id])
      @index = admin_project_taggings_path(@project)
      @taggings = @project.taggings
    end
    if params[:id]
      @tagging = Tagging.find(params[:id])
      @show = admin_page_tagging_path(@tagging)
    end
  end

end
