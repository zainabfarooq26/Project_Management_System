class Users::RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_user!
  
    # GET /users/edit (edit profile)
    def edit
      @user = current_user
    end
  
    # PUT/PATCH /users (update profile)
    def update
        @user = current_user
        if @user.update_with_password(user_params)
          flash[:notice] = "Profile updated successfully"
          redirect_to root_path  # Or any other path where you'd like to redirect
        else
          render :edit  # If there are errors, render the edit form again
        end
      end
      
  
    private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name)
    end
  end