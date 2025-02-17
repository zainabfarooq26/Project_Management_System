module Api
    module V1
      module Manager
        class ProjectsController < Api::V1::BaseController
          before_action :authorize_manager
          before_action :set_project, only: [:show, :update, :destroy]
  
          def index
            @projects = current_user.managed_projects
            render json: @projects, status: :ok
          end
  
          def show
            render json: @project, status: :ok
          end
  
          def create
            @project = Project.new(project_params)
            @project.manager = current_user
            if @project.save
              render json: @project, status: :created
            else
              render json: { error: @project.errors.full_messages }, status: :unprocessable_entity
            end
          end
  
          def update
            if @project.update(project_params)
              render json: @project, status: :ok
            else
              render json: { error: @project.errors.full_messages }, status: :unprocessable_entity
            end
          end
  
          def destroy
            @project.destroy
            render json: { message: 'Project deleted successfully' }, status: :ok
          end
  
          private
          def set_project
            @project = Project.find(params[:id])
          end
  
          def project_params
            params.require(:project).permit(:title, :description, :client_id)
          end
        end
      end
    end
end
  