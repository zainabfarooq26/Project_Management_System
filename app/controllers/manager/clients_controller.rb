class Manager::ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_manager!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.is_manager?
      @clients = current_user.clients  # Managers can see their clients
    else
      @clients = Client.all  # Users can see all clients, but only view
    end
  end

  def show
    # Users and managers can view the client details
  end

  def new
    @client = current_user.clients.build
  end

  def create
    @client = current_user.clients.build(client_params)
    if @client.save
      redirect_to clients_path, notice: 'Client created successfully.'
    else
      render :new
    end
  end

  def edit
    # This will only be accessible for managers
  end

  def update
    if @client.update(client_params)
      redirect_to clients_path, notice: 'Client updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: 'Client deleted successfully.'
  end

  private

  def client_params
    params.require(:client).permit(:name, :email, :phone, :address)
  end

  def set_client
    @client = Client.find(params[:id])
  end

  def authorize_manager!
    redirect_to clients_path, alert: 'Access denied. Managers only.' unless current_user.is_manager?
  end
end
