class Admin::ImagesController < ApplicationController

  def index
    @images = Image.all
    respond_to do |format|
      format.json  { render :json => @images }
    end
  end

  def edit
    @url = @show
    @image = Image.find(params[:id])
  end

  def create
    @image = Image.new(create_params)
    @image.save
  end

  def update
    if @image.update_attributes(create_params)
      redirect_to @project_edit, notice: 'Image was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    respond_to do |format|
      format.json { render :nothing => true }
    end
  end


  private

    def create_params
      params.require(:image).permit(
        :filename, :crop_x, :crop_y, :crop_w, :crop_h
      )
    end

end
