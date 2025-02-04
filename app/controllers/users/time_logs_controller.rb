# app/controllers/users/time_logs_controller.rb
class Users::TimeLogsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @time_logs = current_user.time_logs
    end
  
    def new
      @time_log = current_user.time_logs.build
    end
  
    def create
      @time_log = current_user.time_logs.build(time_log_params)
      if @time_log.save
        redirect_to users_time_logs_path, notice: 'Time log created successfully.'
      else
        render :new
      end
    end
  
    def edit
      @time_log = current_user.time_logs.find(params[:id])
    end
  
    def update
      @time_log = current_user.time_logs.find(params[:id])
      if @time_log.update(time_log_params)
        redirect_to users_time_logs_path, notice: 'Time log updated successfully.'
      else
        render :edit
      end
    end
  
    def destroy
      @time_log = current_user.time_logs.find(params[:id])
      @time_log.destroy
      redirect_to users_time_logs_path, notice: 'Time log deleted successfully.'
    end
  
    private
  
    def time_log_params
      params.require(:time_log).permit(:hours_spent, :date, :project_id)
    end
  end
  