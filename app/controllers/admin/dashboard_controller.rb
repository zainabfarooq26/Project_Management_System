class Admin::DashboardController < ApplicationController
        before_action :authenticate_user!
        before_action :authenticate_admin!
        def index
          @users = User.where(admin: false) # Fetch all non-admin users
        end
      
        private
      
        def authenticate_admin!
          redirect_to root_path, alert: "Access Denied!" unless current_user.admin?
        end
end
      
