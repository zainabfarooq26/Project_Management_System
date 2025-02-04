class UsersController < ApplicationController
    before_action :authenticate_user!
  def index
    @users = User.all # Or, you can filter it to only show the current user with User.where(id: current_user.id)
  end
  
end
