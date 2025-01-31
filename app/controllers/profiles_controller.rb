class ProfilesController < ApplicationController
  before_action :authenticate_user! # Ensure the user is logged in before accessing these actions
  def edit
    @user = current_user
  end
  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to root_path, notice: 'Profile updated successfully!'
    else
      render :edit
    end
  end
  private
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :profile_photo, :password, :password_confirmation)
  end
end
