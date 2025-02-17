module Api
    module V1
      module Admin
        class ProjectsController < Api::V1::BaseController
          before_action :authorize_admin
          before_action:set_project,only:[:update,:delete]
          before_action:payment_params,only:[:create]
  
          def create
            @project = Project.new(project_params)
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
            render json: { message: 'Project deleted successfully'}, status: :ok
          end
  
          private
          def authorize_admin
            render json: { error: 'Not authorized'}, status: :forbidden unless current_user.admin?
          end
  
          def set_project
            @project = Project.find(params[:id])
          end

          def project_params
            params.require(:project).permit(:title, :description, :manager_id, :client_id)
          end
        end
      end
    end
end
  