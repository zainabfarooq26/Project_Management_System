class Manager::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client
  before_action :set_project, only: %i[show edit update destroy]
  before_action :authorize_manager, only: %i[new create edit update destroy] 

  def assigned_projects
    @projects = current_user.projects.includes(:manager) 
  end
  
  def assign_users
    @project = Project.find(params[:id]) 
    @users = User.where.not(admin: true) 
    if request.post?
      Rails.logger.debug 'Params received: #{params.inspect}'  
  
      user_ids = params[:project][:user_ids].reject(&:blank?) rescue []
      Rails.logger.debug 'User IDs to assign: #{user_ids}'
  
      if user_ids.any?
        @project.user_ids = user_ids 
        if @project.save
          flash[:notice] = 'Users assigned successfully!'
          redirect_to  manager_client_projects_path(@client)
        else
          flash[:alert] = 'Failed to assign users.'
        end
      else
        flash[:alert] = 'No users selected.'
      end
    end
  end

  def remove_user
    @project = Project.find(params[:id])
    user = User.find(params[:user_id])

    if @project.users.delete(user)  
      flash[:notice] = '#{user.first_name} #{user.last_name} was removed from the project.'
    else
      flash[:alert] = 'Failed to remove user from the project.'
    end
    redirect_to assign_users_manager_client_project_path(@project.client, @project)
    end
         
  def new
    @project = @client.projects.build
  end
 
  def index
      @client = Client.find(params[:client_id])
      @projects = ProjectsSearchService.new(@client, params[:search_query], params[:search_category], params[:sort]).call
  end
  
  def create
    @project = @client.projects.build(project_params)
    @project.manager = current_user

    if @project.save
      redirect_to manager_client_projects_path(@client), notice: 'Project created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def show
    @project = Project.find(params[:id])
    @comments = @project.comments.order(created_at: :desc).limit(5)
    @time_log = TimeLog.new 
    @comment = Comment.new
  end

  def update
    if @project.update(project_params)
      flash[:success] = 'Project updated successfully!'
      redirect_to manager_client_projects_path(@client)
    else
      flash[:error] = 'Error updating project!'
      render :edit
    end
  end

  def destroy
    @project.destroy
    flash[:success] = 'Project deleted successfully!'
    redirect_to manager_client_projects_path(@client)
  end

  private
  def set_client
    @client = Client.find(params[:client_id])
 end

 def set_project
   @project = @client.projects.find(params[:id])
 end

  def set_project
    @project = @client.projects.find(params[:id])
    redirect_to manager_client_projects_path(@client)
  end

  def project_params
    params.require(:project).permit(:title, :description, attachments: [])
  end

  def authorize_manager
    redirect_to root_path, alert: 'Unauthorized' unless current_user.manager?
  end
  
end