class Manager::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client
  before_action :set_project, only: %i[show edit update destroy]
  before_action :authorize_manager, only: %i[new create edit update destroy] 

      def assign_users
        @project = Project.find(params[:id]) # Ensure we are getting the correct project
        @users = User.where.not(admin: true) # Exclude admins
        if request.post?
          Rails.logger.debug "Params received: #{params.inspect}"  # Debugging line
      
          user_ids = params[:project][:user_ids].reject(&:blank?) rescue []
          Rails.logger.debug "User IDs to assign: #{user_ids}"
      
          if user_ids.any?
            @project.user_ids = user_ids # Assign users to project
            if @project.save
              flash[:notice] = "Users assigned successfully!"
            else
              flash[:alert] = "Failed to assign users."
            end
          else
            flash[:alert] = "No users selected."
          end
      
          redirect_to manager_client_projects_path(@project.client)
        end
      end
  
  
  def index
    @client = Client.find(params[:client_id])
    if current_user.is_manager?
      @projects = @client.projects
    else
      @projects = @client.projects
    end
    @project = @projects.first
  end

  def new
    @project = @client.projects.build
  end

  def create
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
    # Only managers can edit projects
  end

  def show
    # Both users and managers can view project details
    @time_log = TimeLog.new # Allow users to create time logs
    @comment = Comment.new # Allow users to create comments
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