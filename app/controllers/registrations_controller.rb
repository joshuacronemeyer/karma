class RegistrationsController < Devise::RegistrationsController


protected

  def after_update_path_for(resource)
    user_path(current_user)
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end

end
