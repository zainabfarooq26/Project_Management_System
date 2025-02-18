class Manager::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_manager!
  
  def index;end
  
  private
  def authorize_manager!
    redirect_to root_path, alert: 'Access denied.' unless current_user.manager?
  end
end
