# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_user_status, if: :user_signed_in?
  # Skip confirmation for admin users (skip only on admin actions)
  def check_user_status
    if current_user.active == false
      sign_out current_user
      redirect_to new_user_session_path, alert: "Your account has been locked by an admin."
    end
  end
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path # Redirect to admin dashboard
    elsif resource.is_manager? 
      manager_clients_path  # Redirect manager to manager dashboard
    else
      manager_clients_path  # Redirect normal users to homepage
    end
  end

  private

  def admin_signed_in?
    current_user&.admin?
  end
  
end
