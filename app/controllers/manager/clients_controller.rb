class Manager::ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_manager!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  
  def index
    if current_user.is_manager?
      @clients = current_user.clients  
    else
      @clients = Client.all  
    end
    if params[:search_query].present?
      query = "%#{params[:search_query]}%"
      case params[:search_category]
      when "name"
        @clients = @clients.where("name ILIKE ?", query)
      when "email"
        @clients = @clients.where("email ILIKE ?", query)
      when "phone"
        @clients = @clients.where("phone ILIKE ?", query)
      when "address"
        @clients = @clients.where("address ILIKE ?", query)
      when "project_title"
        @clients = @clients.joins(:projects).where("projects.title ILIKE ?", query).distinct
      else
        @clients = @clients.left_joins(:projects).where(
          "clients.name ILIKE ? OR clients.email ILIKE ? OR clients.phone ILIKE ? OR clients.address ILIKE ? OR projects.title ILIKE ?", 
          query, query, query, query, query
        ).distinct
      end
    end
  end

  def show
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
