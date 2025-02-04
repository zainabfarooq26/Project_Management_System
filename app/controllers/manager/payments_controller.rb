class Manager::PaymentsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_manager
    before_action :set_project
    before_action :set_payment, only: %i[edit update destroy]
  
    def index
      @client = Client.find(params[:client_id])
      @project = @client.projects.find(params[:project_id])
      @payments = @project.payments
    end
  

    def new
      @client = Client.find(params[:client_id])  # Ensure the client is found using client_id from params
      @project = @client.projects.find(params[:project_id])  # Find the project using project_id
      @payment = @project.payments.build
    end
          

    def create
      @client = Client.find(params[:client_id])
      @project = @client.projects.find(params[:project_id])
      @payment = @project.payments.build(payment_params)
      if @payment.save
        redirect_to manager_client_project_payments_path(@client, @project), notice: 'Payment created successfully!'
      else
        render :new
      end
    end
  
    def edit
      @client = @project.client
    end
  
    def update
      @client = @project.client  # Ensure @client is set based on the project
      if @payment.update(payment_params)
        flash[:success] = "Payment updated successfully!"
        redirect_to manager_client_project_payments_path(@client, @project)
      else
        flash[:error] = "Error updating payment!"
        render :edit
      end
    end
  
    def destroy
      @payment.destroy
      flash[:success] = "Payment deleted successfully!"
      redirect_to manager_project_payments_path(@project)
    end
  
    private
  
    def set_project
      @project = current_user.projects.find(params[:project_id])  # Only the manager's projects
    end
  
    def set_payment
      @payment = @project.payments.find(params[:id])  # Find the specific payment for the project
    end
  
    def payment_params
      params.require(:payment).permit(:amount, :paid_on,:status)
    end
  
    def authorize_manager
      redirect_to root_path, alert: "Unauthorized" unless current_user.is_manager?
    end
  end
  