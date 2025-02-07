class Manager::PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_manager
  before_action :set_project
  before_action :set_client
  before_action :set_payment, only: %i[edit update destroy]

  def index
    @payments = @project.payments
  end

  def new
    @payment = @project.payments.build
  end

  def create
    @payment = @project.payments.build(payment_params)

    if @payment.save
      redirect_to manager_client_project_payments_path(@client, @project), notice: 'Payment created successfully!'
    else
      flash.now[:alert] = "Error creating payment!"
      render :new
    end
  end

  def edit; end

  def update
    if @payment.update(payment_params)
      redirect_to manager_client_project_payments_path(@client, @project), notice: 'Payment updated successfully!'
    else
      flash.now[:alert] = "Error updating payment!"
      render :edit
    end
  end

  def destroy
    if @payment.destroy
      redirect_to manager_client_project_payments_path(@client, @project), notice: 'Payment deleted successfully!'
    else
      redirect_to manager_client_project_payments_path(@client, @project), alert: 'Error deleting payment!'
    end
  end

  private

  def set_project
    puts "Project ID from params: #{params[:project_id]}" # Debugging
  @project = Project.find_by(id: params[:project_id])

  if @project.nil?
    flash[:alert] = "⚠️ Project not found!"
    redirect_to manager_assigned_projects_path and return
  end

  # Allow managers to access all projects, but limit non-managers to assigned projects
  if !current_user.is_manager? && !current_user.projects.exists?(@project.id)
    flash[:alert] = "⚠️ You are not assigned to this project!"
    redirect_to manager_client_projects_path and return
  end
  end

  def set_client
    if @project.present?
      @client = @project.client
    else
      flash[:alert] = "⚠️ Project not found!"
      redirect_to manager_client_projects_path and return
    end
  end

  def set_payment
    @payment = @project.payments.find_by(id: params[:id])

    if @payment.nil?
      flash[:alert] = "⚠️ Payment not found!"
      redirect_to manager_client_project_payments_path(@client, @project) and return
    end
  end

  def payment_params
    params.require(:payment).permit(:amount, :paid_on, :status)
  end

  def authorize_manager
    redirect_to root_path, alert: "Unauthorized" unless current_user.is_manager?
  end
end
