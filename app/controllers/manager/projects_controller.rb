class Manager::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_manager
  before_action :set_client
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @client = Client.find(params[:client_id]) # Ensure @client is assigned
    @projects = @client.projects # Fetch all projects for the client
  end
  

  def new
    @project = @client.projects.build
  end

  def create
   @client = Client.find(params[:client_id])
   @project = @client.projects.build(project_params)
   @project.manager = current_user
  if @project.save
    redirect_to manager_client_projects_path(@client), notice: "Project created successfully."
  else
    Rails.logger.debug "Project Errors: #{@project.errors.full_messages}" 
    render :new
  end
  end

  def edit
  end

  def show
  end

  def update
    if @project.update(project_params)
      flash[:success] = "Project updated successfully!"
      redirect_to manager_client_projects_path(@client)
    else
      flash[:error] = "Error updating project!"
      render :edit
    end
  end

  def destroy
    @project.destroy
    flash[:success] = "Project deleted successfully!"
    redirect_to manager_client_projects_path(@client)
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Client not found!"
    redirect_to manager_clients_path
  end

  def set_project
    @project = @client.projects.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Project not found!"
    redirect_to manager_client_projects_path(@client)
  end

  def project_params
    params.require(:project).permit(:title, :description, attachments: [])
  end

  def authorize_manager
    redirect_to root_path, alert: "Unauthorized" unless current_user.is_manager?
  end
end
