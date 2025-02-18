module Api
  module V1
    class BaseController < ActionController::API  
      before_action :authenticate_request
      private
      def authenticate_request
        header = request.headers['Authorization']
        token = header.split(' ').last if header.present?
        if token.blank?
          render json: { error: 'Missing token' }, status: :unauthorized
          return
        end
        begin
          decoded_token = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base),
          true, algorithm: 'HS256')
          Rails.logger.info "Decoded Token: #{decoded_token}"  
          user_id = decoded_token[0]['user_id']  
          if user_id.nil?
            render json: { error: 'Invalid token payload: User ID missing' }, status: :unauthorized
            return
          end
          @current_user = ::User.find(user_id)
         end
        end
      def current_user
        @current_user
      end
    
      def authorize_admin
        render json: { error: "Not authorized" }, status: :forbidden unless
         current_user&.admin?
      end
    
      def authorize_manager
        render json: { error: "Not authorized" }, status: :forbidden unless 
        current_user&.manager? || current_user&.admin?
      end
    
      def authorize_user
        render json: { error: "Not authorized" }, status: :forbidden unless
         current_user&.user? || current_user&.manager? || current_user&.admin?
      end
    end
  end
end