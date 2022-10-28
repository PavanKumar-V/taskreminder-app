class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :user_avatar, ifnot: :session_controller

  def change_avatar
    avatar = Avatar.find(params[:id])

    if (avatar)
      user = User.find(current_user.id)
      user.update({avatar_id: params[:id]})
      redirect_to "/users/edit/", notice: "Avatar Updated"
    else
      redirect_to "/users/edit/", alert: "Avatar Could not be updated"
    end
  end


 protected

 def user_avatar
  if user_signed_in?
    if current_user.avatar_id
      @avatar = Avatar.find(current_user.avatar_id);
    end

  end
 end

 def configure_permitted_parameters
  attributes = [:full_name, :email]
  devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
  devise_parameter_sanitizer.permit(:account_update, keys: attributes)
end
end
