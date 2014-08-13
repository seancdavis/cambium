class Admin::PostsController < AdminController

  def new
    @image = Image.new
    @image_url = admin_images_path(@image)
    super
    @item.user = current_user
  end

  def edit
    @image = Image.new
    @image_url = admin_images_path(@image)
    super
  end

  private
    def set_defaults
      super
      @model = Post
    end

    def create_params
      params.require(:post).permit(
        :title,
        :body,
        :slug,
        :active_date,
        :active_time,
        :inactive_date,
        :inactive_time,
        :main_image,
        :remove_main_image,
        :is_featured,
        :user_id,
        :tag_list
      )
    end

end
