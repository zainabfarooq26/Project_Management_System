class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user! # Ensure users are logged in
  before_action :check_user_status, if: :user_signed_in?
  def check_user_status
    if current_user.locked?
      sign_out current_user
      redirect_to new_user_session_path, alert: "Your account has been locked by an admin."
    end
  end
  def after_sign_in_path_for(resource)
    if resource.admin? # Check if user is an admin
      admin_dashboard_path # Redirect admin to the admin dashboard
    else
      root_path # Redirect normal users to the homepage
    end
  end
end
