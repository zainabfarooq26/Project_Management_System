module Api
    module V1
      module Manager
        class PaymentsController < Api::V1::BaseController
          before_action :authorize_manager
          before_action :set_payment, only: [:update, :destroy]
          
          def create
            @payment = Payment.new(payment_params)
            if @payment.save
              render json: @payment, status: :created
            else
              render json: { error: @payment.errors.full_messages }, status: :unprocessable_entity
            end
          end
  
          def update
            if @payment.update(payment_params)
              render json: @payment, status: :ok
            else
              render json: { error: @payment.errors.full_messages }, status: :unprocessable_entity
            end
          end
  
          def destroy
            @payment.destroy
            render json: { message: "Payment deleted successfully" }, status: :ok
          end
  
          private
          def payment_params
            params.require(:payment).permit(:amount, :paid_on, :status, :project_id)
          end
          def set_payment
            @payment = Payment.find(params[:id])
          end
        end
      end
    end
  end
  