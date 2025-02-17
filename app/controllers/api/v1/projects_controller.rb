module Api
  module V1
    class ProjectsController < Api::V1::BaseController
      before_action :authenticate_request

      def index
        @projects=Project.all
        render json: @projects, status: :ok
      end
      def search
        api_search_service = ApisSearchService.new(params)
        @projects = api_search_service.search
        if @projects.empty?
          render json: { error: 'No projects found matching your criteria' }, status: :not_found
        else
          render json: @projects, status: :ok
        end
      end

      private
      def fetch_projects
        if current_user.admin?
          Project.includes(:users, :manager, :time_logs).all
        elsif current_user.manager?
          Project.includes(:users, :manager, :time_logs).where(manager_id: current_user.id)
        else
          Project.includes(:users, :manager, :time_logs).joins(:users).where(users: { id: current_user.id })
        end
      end
    end
  end
end
