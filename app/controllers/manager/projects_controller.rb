class Manager::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client
  before_action :set_project, only: %i[show edit update destroy assign_users remove_user]
  before_action :authorize_manager, only: %i[new create edit update destroy]

  def assign_users
    @users = User.not_admin
    if request.post?
      user_ids = params[:project][:user_ids].presence || []
      if user_ids.any?
         @project.users << User.where(id: user_ids).where.not(id: @project.user_ids) 
        if @project.save
          flash[:notice] = 'Users assigned successfully!'
          redirect_to manager_client_projects_path(@client)
        else
          flash[:alert] = 'Failed to assign users.'
        end
      else
        flash[:alert] = 'No users selected.'
      end
    end
  end

  def remove_user
    user = User.find_by(id: params[:user_id])
    if user && @project.users.delete(user)
      flash[:notice] = "#{user.first_name} #{user.last_name} was removed from the project."
    else
      flash[:alert] = 'Failed to remove user from the project.'
    end
    redirect_to assign_users_manager_client_project_path(@project.client, @project)
  end

  def index
      @projects = ProjectsSearchService.new(@client, params[:search_query], params[:search_category], params[:sort])
                                       .call
                                       .includes(:users, :manager, time_logs: :user)
  end

  def new
    @project = @client.projects.build
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

  def show
    @project = @client.projects.includes(:users, :manager, time_logs: :user).find(params[:id])
    @comments = @project.comments.order(created_at: :desc).limit(5)
    @time_log = TimeLog.new
    @comment = Comment.new
  end

  def update
    if @project.update(project_params)
      redirect_to manager_client_projects_path(@client), notice: 'Project updated successfully!'
    else
      flash[:alert] = 'Error updating project!'
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to manager_client_projects_path(@client), notice: 'Project deleted successfully!'
  end

  private
  def set_client
    @client = Client.find(params[:client_id])
  end

  def set_project
    @project = @client.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, attachments: [])
  end

  def authorize_manager
    redirect_to root_path, alert: 'Unauthorized' unless current_user.manager?
  end
end
