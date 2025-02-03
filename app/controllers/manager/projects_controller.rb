class Manager::ProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_manager
    before_action :set_project, only: %i[show edit update destroy]
  
    def index
      @projects = current_user.projects # Only show projects created by the logged-in manager
    end
  
    def new
      @project = current_user.projects.build
    end
  
    def create
      @project = current_user.projects.build(project_params)
      if @project.save
        flash[:success] = "Project created successfully!"
        redirect_to manager_projects_path
      else
        flash[:error] = "Error creating project!"
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
        redirect_to manager_projects_path
      else
        flash[:error] = "Error updating project!"
        render :edit
      end
    end
  
    def destroy
      @project.destroy
      flash[:success] = "Project deleted successfully!"
      redirect_to manager_projects_path
    end
  
    private
  
    def set_project
      @project = current_user.projects.find(params[:id]) # Managers can only access their own projects
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Project not found!"
      redirect_to manager_projects_path
    end
  
    def project_params
      params.require(:project).permit(:title, :description,attachments: [])
    end
  
    def authorize_manager
      redirect_to root_path, alert: "Unauthorized" unless current_user.is_manager?
    end
  end
  