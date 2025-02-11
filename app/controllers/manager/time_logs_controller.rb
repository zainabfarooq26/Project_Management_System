class Manager::TimeLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_time_log, only: [:destroy, :edit, :update]
  before_action :check_assignment, only: [:new, :create, :edit, :update, :destroy]

  def new
    @time_log = @project.time_logs.build
  end

  def create
    @time_log = @project.time_logs.build(time_log_params.merge(user: current_user))

    if @time_log.save
      redirect_to manager_client_projects_path(@client, @project), notice: 'Time log added successfully.'
    else
      redirect_to manager_client_projects_path(@client, @project), alert: 'Failed to add time log.'
    end
  end

  def edit
  end

  def update
    if @time_log.update(time_log_params)
      redirect_to manager_client_projects_path(@client, @project), notice: 'Time log updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @time_log.destroy
    redirect_to manager_client_projects_path(@client, @project), notice: 'Time log was successfully deleted.'
  end

  private
  def set_project
    @client = Client.find(params[:client_id])
    @project = @client.projects.find(params[:project_id])
  end

  def time_log_params
    params.require(:time_log).permit(:hours)
  end

  def set_time_log
    @time_log = @project.time_logs.find(params[:id])
  end

  def check_assignment
    unless current_user.projects.exists?(@project.id)
      redirect_to manager_client_projects_path(@client, @project), alert: 'You are not assigned to this project.'
    end
  end
end
