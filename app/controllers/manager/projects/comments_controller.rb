module Manager
  module Projects
    class CommentsController < ApplicationController
      before_action :authenticate_user!

      def create
        @project = Project.find(params[:project_id])
        @comment = @project.comments.build(comment_params.merge(user: current_user))

        if @comment.save
          redirect_to manager_client_project_path(@project.client, @project), notice: "Comment added."
        else
          redirect_to manager_client_project_path(@project.client, @project), alert: "Failed to add comment."
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end
