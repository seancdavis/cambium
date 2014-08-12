class Admin::PagesController < AdminController

  def index
    @items = @model.all.unscoped.order(:title)
    if @model.respond_to?(:for_location) && current_user.is_location_admin
      @items = @items.for_location(current_user.location_id)
    end
  end

  def new
    @image = Image.new
    @image_url = admin_images_path(@image)
    super
  end

  def edit
    @image = Image.new
    @image_url = admin_images_path(@image)
    super
  end

  def update
    update_params ||= create_params
    if @item.update(update_params)
      @item.update_column(:slug, @item.create_slug)
      redirect_to edit_admin_page_path(@item), :notice => "#{@model.to_s} was updated successfully."
    else
      render :action => "edit"
    end
  end


  private
    def set_defaults
      super
      @model = Page
    end

    def create_params
      params.require(:page).permit(:title, :body, :slug, :position, :template,
        :description, :active_date, :active_time, :inactive_date, :in_top_nav,
        :inactive_time, :parent_id)
    end

end
