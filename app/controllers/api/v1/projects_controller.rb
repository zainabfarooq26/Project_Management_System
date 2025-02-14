module Api
    module V1
      class ProjectsController < ApplicationController
        def index
          projects = Project.all
          render json: projects, status: :ok
        end
  
        def show
          project = Project.find(params[:id])
          render json: project, status: :ok
        end
       end
    end
end
  