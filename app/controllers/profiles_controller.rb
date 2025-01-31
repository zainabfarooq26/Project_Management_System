
class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile

    # Update the profile with the permitted parameters
    if @profile.update(profile_params)
      flash[:notice] = "Profile updated successfully"
      redirect_to profile_path(@profile)
    else
      flash[:alert] = "There was an error updating your profile"
      render :edit
    end
  end

  private
  def profile_params
    # Ensure profile_photo is permitted
    params.require(:profile).permit(:first_name, :last_name, :profile_photo)
  end
end

