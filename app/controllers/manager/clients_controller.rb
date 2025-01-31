class Manager::ClientsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_manager!
  
    def index
      @clients = current_user.clients  # Only show clients created by this manager
    end
  
    def show
      @client = current_user.clients.find(params[:id])
    end
  
    def new
      @client = current_user.clients.build
    end
  
    def create
      @client = current_user.clients.build(client_params)
      if @client.save
        redirect_to manager_clients_path, notice: 'Client created successfully.'
      else
        render :new
      end
    end
  
    def edit
      @client = current_user.clients.find(params[:id])
    end
  
    def update
      @client = current_user.clients.find(params[:id])
      if @client.update(client_params)
        redirect_to manager_clients_path, notice: 'Client updated successfully.'
      else
        render :edit
      end
    end
  
    def destroy
      @client = current_user.clients.find(params[:id])
      @client.destroy
      redirect_to manager_clients_path, notice: 'Client deleted successfully.'
    end
  
    private
  
    def client_params
      params.require(:client).permit(:name, :email, :phone, :address)
    end
  
    def authorize_manager!
      redirect_to root_path, alert: 'Access denied.' unless current_user.is_manager?
    end
  end
  