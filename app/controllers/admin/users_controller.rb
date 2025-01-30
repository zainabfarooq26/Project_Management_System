class Admin::UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin!
  
    def index
      @users = User.where(admin: false) # Show all non-admin users
    end
    def toggle_status
      @user = User.find(params[:id])
      @user.update(active: !@user.active) # Toggle active status
  
      flash[:notice] = @user.active? ? "User enabled successfully." : "User disabled successfully."
      redirect_to admin_users_path
    end
  
    private
  
    def authenticate_admin!
      redirect_to root_path, alert: "Access Denied!" unless current_user.admin?
    end
  end
  