class Manager::PaymentsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_manager
    before_action :set_project
    before_action :set_payment, only: %i[edit update destroy]
  
    def index
      @payments = @project.payments
    end
  

    def new
      @project = current_user.projects.find(params[:project_id])
      @payment = @project.payments.build
    end
          

    def create
      @payment = @project.payments.build(payment_params)
      if @payment.save
        if @payment.paid_on > Date.today
            flash[:notice] = "Payment is scheduled for #{l(@payment.paid_on, format: :long)}"
        else
        flash[:success] = "Payment added successfully!"
        end
        redirect_to manager_project_payments_path(@project)
      else
        flash[:error] = "Error adding payment!"
        render :new
      end
    end
  
    def edit; end
  
    def update
      if @payment.update(payment_params)
        flash[:success] = "Payment updated successfully!"
        redirect_to manager_project_payments_path(@project)
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
  