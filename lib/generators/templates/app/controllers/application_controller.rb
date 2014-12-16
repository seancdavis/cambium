

  # redirect to admin dashboard after signing in
  def after_sign_in_path_for(user)
    root_path
  end

  # redirect back to sign in form when signed out
  def after_sign_out_path_for(user)
    root_path
  end
