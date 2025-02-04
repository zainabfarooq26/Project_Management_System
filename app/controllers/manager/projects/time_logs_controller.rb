module Manager
  module Projects
    class TimeLogsController < ApplicationController
      before_action :authenticate_user!

      def create
        @project = Project.find(params[:project_id])
        @time_log = @project.time_logs.build(time_log_params.merge(user: current_user))

        if @time_log.save
          redirect_to manager_client_project_path(@project.client, @project), notice: "Time log added."
        else
          redirect_to manager_client_project_path(@project.client, @project), alert: "Failed to add time log."
        end
      end

      private

      def time_log_params
        params.require(:time_log).permit(:hours)
      end
    end
  end
end
