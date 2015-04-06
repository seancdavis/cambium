module Cambium
  class Admin::UsersController < AdminController

    def update
      set_object
      # To make this run smoothly, we remove the password
      # fields from the update_params if they are both
      # missing, that way we don't try to set a blank
      # password.
      p = update_params
      if p[:password].blank? && p[:password_confirmation].blank?
        p = p.except('password','password_confirmation')
      end
      # Now we use the cleansed params `p` and we're ready
      # to try to save the user
      if @object.update(p)
        # If we have successfully saved the user, we're
        # going to sign them back in automatically.
        if @object == current_user
          sign_in(@object, :bypass => true)
        end
        # And then we oome back to regular behavior
        redirect_to(admin_routes.index, :notice => "#{admin_model.to_s} updated!")
      else
        render 'edit'
      end
    end

  end
end
