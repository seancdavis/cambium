class Admin::UsersController < AdminController

  private
    def set_defaults
      super
      @model = User
      @columns = ['email']
    end

    def create_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
