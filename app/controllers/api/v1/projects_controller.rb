module Api
    module V1
      class ProjectsController < ApplicationController
        before_action :authenticate_request
        def index
          @projects = Project.includes(:users, :manager, :time_logs).all
          render json: @projects.to_json(
            only: [:id, :title, :description, :created_at, :updated_at],
            include: {
              users: { only: [:id, :email] },
              manager: { only: [:id, :email] }
            }
          ), status: :ok
        end
       end
    end
end
  