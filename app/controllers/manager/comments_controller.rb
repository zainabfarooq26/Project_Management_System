class Manager::CommentsController < ApplicationController
    before_action :set_project
  
    def new
      @comment = @project.comments.new
    end
  
    def create
      @comment = @project.comments.new(comment_params)
      if @comment.save
        redirect_to manager_client_project_path(@client, @project)
      else
        render :new
      end
    end
  
    private
  
    def set_project
      @client = Client.find(params[:client_id])
      @project = @client.projects.find(params[:project_id])
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end
  