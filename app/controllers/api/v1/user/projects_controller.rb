module Api
    module V1
      module User
        class ProjectsController < Api::V1::BaseController
          before_action :authorize_user
          before_action :set_project, only: [:show]

          def index
            @projects = current_user.projects.includes(:client)
            render json: @projects, status: :ok
          end
  
          def show
            render json: @project, status: :ok
          end
  
          private
          def set_project
            @project = current_user.projects.find_by(id: params[:id])
            render json: { error: "Project not found" }, status: :not_found unless @project
          end
        end
      end
    end
end