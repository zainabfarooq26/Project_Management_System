module Api
    module V1
      class ApplicationController < ::ApplicationController
        protect_from_forgery with: :null_session
        before_action :authenticate_user!
        before_action :authorize_role
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
        rescue_from StandardError, with: :handle_standard_error
  
        private
        def authorize_role
          return if current_user.admin? 
          if manager_request? && !current_user.manager?
            render json: { error: "Not authorized" }, status: :forbidden
          elsif user_request? && !(current_user.manager? || current_user.user?)
            render json: { error: "Not authorized" }, status: :forbidden
          end
        end

        def manager_request?
          request.path.start_with?("/api/v1/manager")
        end

        def user_request?
          request.path.start_with?("/api/v1/user")
        end
  
        def record_not_found
          render json: { error: 'Record not found' }, status: :not_found
        end
  
        def handle_standard_error(exception)
          render json: { error: exception.message }, status: :internal_server_error
        end
      end
    end
end
  