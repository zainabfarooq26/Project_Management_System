class Users::RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_user!
  
    def edit
      @user = current_user
    end
  
    def update
        @user = current_user
        if @user.update_with_password(user_params)
          flash[:notice] = "Profile updated successfully"
          redirect_to root_path 
        else
          render :edit  
        end
      end
      
    private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name)
    end
  end