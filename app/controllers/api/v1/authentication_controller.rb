module Api
    module V1
      class AuthenticationController < Api::V1::BaseController
        before_action :authenticate_user!, only: [:logout]
        skip_before_action :authenticate_request, only: [:login, :register]
        def register
          user = ::User.new(user_params)
          if user.save
            token = JsonWebToken.encode(user_id: user.id)
            render json: { token: token, user: user }, status: :created
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def login
            user = ::User.find_by(email: params[:email])  
            if user&.valid_password?(params[:password])
              token = JsonWebToken.encode(user_id: user.id)  
              render json: { token: token, user: user }, status: :ok
            else
              render json: { error: "Invalid Email or Password" }, status: :unauthorized
            end
        end
          
        def logout
          render json: { message: 'Logged out successfully' }, status: :ok
        end
  
        private
        def user_params
          params.permit(:email, :password, :password_confirmation)
        end
      end
    end
end
  