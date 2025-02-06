class Manager::CommentsController < ApplicationController
  before_action :set_project
  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
    @comment = @project.comments.new
  end

  def create
    @comment = @project.comments.new(comment_params)
  @comment.user = current_user  # Associate the comment with the current user

  if @comment.save
    respond_to do |format|
      format.html { redirect_to manager_client_projects_path(@client, @project) }
      format.js   # This will look for create.js.erb to render
    end
  else
    render :new
  end
end

  def edit
    # @comment is set via before_action
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.html { redirect_to manager_client_projects_path(@client, @project) }
        format.js   # This will look for update.js.erb to render
      end
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to manager_client_projects_path(@client, @project)
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
end
