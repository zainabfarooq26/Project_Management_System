class Manager::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :check_assignment, only: [:new, :create, :edit, :update, :destroy]

  def new
    @comment = @project.comments.new
  end

  def create
    @comment = @project.comments.new(comment_params.merge(user: current_user)) 
    if @comment.save
      respond_to do |format|
        format.html { redirect_to manager_client_projects_path(@client, @project), notice: 'Comment added successfully.' }
        format.js   
      end
    else
      render :new
    end
  end

  def edit;end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.html { redirect_to manager_client_projects_path(@client, @project), notice: 'Comment updated successfully.' }
        format.js  
      end
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to manager_client_projects_path(@client, @project), notice: 'Comment deleted successfully.'
  end

  private
  def set_project
    @client = Client.find(params[:client_id])
    @project = @client.projects.find(params[:project_id])
  end

  def set_comment
    @comment = @project.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def check_assignment
    unless current_user.projects.exists?(@project.id)
      redirect_to manager_client_projects_path(@client, @project), alert: "You are not assigned to this project."
    end
  end
end
