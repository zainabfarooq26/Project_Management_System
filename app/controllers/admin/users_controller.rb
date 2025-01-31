class Admin::UsersController < ApplicationController
    before_action :authenticate_admin!
    def index
      @users = User.where.not(admin: true)  # Excluding admin users
    end
    def new
        @user = User.new
      end
    def create
        @user = User.new(user_params)
    
        if @user.save
          redirect_to admin_users_path, notice: 'User was successfully created.'
        else
          render :new, alert: 'There was an error creating the user.'
        end
    end
    def show
      @user = User.find(params[:id])
    end
    def edit
      @user = User.find(params[:id])
    end
    def update
        @user = User.find(params[:id])
      
        if @user.update(user_params)
          redirect_to admin_dashboard_index_path, notice: 'User updated successfully.'
        else
          flash.now[:alert] = 'Failed to update user.'
          render :edit
        end
      end
      def destroy
      @user = User.find(params[:id])
      @user.destroy
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove("user_#{@user.id}") }
        format.html { redirect_to admin_users_path, notice: 'User deleted successfully.' }
       end
      end
  
    def toggle_status
        @user = User.find(params[:id])
        @user.update(active: !@user.active)
      
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("user_#{@user.id}", partial: "admin/users/user_row", locals: { user: @user }) }
          format.html { redirect_to admin_users_path, notice: 'User status updated.' }
        end
      end
      
      def toggle_manager
        @user = User.find(params[:id])
        @user.update(is_manager: !@user.is_manager)
      
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("user_#{@user.id}", partial: "admin/users/user_row", locals: { user: @user }) }
          format.html { redirect_to admin_users_path, notice: 'User manager rights updated.' }
        end
      end

    private
    def user_params
        params.require(:user).permit(:name, :email, :role, :password, :password_confirmation)
      end
    # Custom method to ensure only admin can access these actions
    def authenticate_admin!
      redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
    end
  end
  