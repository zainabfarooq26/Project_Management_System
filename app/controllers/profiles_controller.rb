
class ProfilesController < ApplicationController
  before_action :authenticate_user!
  def show
    @profile = current_user.profile
  end
  def edit
    @profile = current_user.profile
  end
  def update
    @profile = current_user.profile
    if @profile.update(profile_params)
      flash[:notice] = 'Profile updated successfully'
      redirect_to profile_path(@profile)
    else
      flash[:alert] = 'There was an error updating your profile'
      render :edit
    end
  end
  private
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :profile_photo)
  end
end

