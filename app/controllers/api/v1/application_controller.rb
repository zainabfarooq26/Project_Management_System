module Api
    module V1
      class ApplicationController < ::ApplicationController
        protect_from_forgery with: :null_session
        before_action :authenticate_request
        attr_reader :current_user

        private
        def authenticate_request
            header = request.headers["Authorization"]
            Rails.logger.info "Authorization Header: #{header}"  # Debugging line
            if header.blank?
              render json: { error: "No verification key available" }, status: :unauthorized
              return
            end
            token = header.split(" ").last
            Rails.logger.info "Extracted Token: #{token}"  # Debugging line
            begin
              decoded_token = JsonWebToken.decode(token)
              Rails.logger.info "Decoded Token: #{decoded_token}"  # Debugging line
              @current_user = User.find(decoded_token[:user_id])
            rescue ActiveRecord::RecordNotFound
              render json: { error: "User not found" }, status: :unauthorized
            rescue JWT::DecodeError
              render json: { error: "Invalid or expired token" }, status: :unauthorized
            end
          end
      end
    end
end
  