class Users::CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_project
    before_action :set_comment, only: %i[edit update destroy]
  
    def index
      @comments = @project.comments
    end
  
    def new
      @comment = @project.comments.build
    end
  
    def create
      @comment = @project.comments.build(comment_params)
      @comment.user = current_user # Associate the comment with the logged-in user
      if @comment.save
        redirect_to users_project_comments_path(@project), notice: 'Comment created successfully.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @comment.update(comment_params)
        redirect_to users_project_comments_path(@project), notice: 'Comment updated successfully.'
      else
        render :edit
      end
    end
  
    def destroy
      @comment.destroy
      redirect_to users_project_comments_path(@project), notice: 'Comment deleted successfully.'
    end
  
    private
  
    def set_project
      @project = current_user.projects.find(params[:project_id])  # Ensure users can only see their own projects
    end
  
    def set_comment
      @comment = @project.comments.find(params[:id])  # Find the comment within the project
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end
  