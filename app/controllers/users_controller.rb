class UsersController < ApplicationController
  before_action :require_admin, except: [ :show ]
  before_action :set_user, only: [ :show, :update, :destroy ]

  def index
    @users = User.all.order(:email)
    @new_user = User.new  # For the new user form
  end

  def show
    # Allow users to view their own profile, or require admin for others
    unless Current.user == @user || Current.user&.admin?
      redirect_to root_path, alert: "Access denied."
      nil
    end
  end

  def create
    @new_user = User.new(user_params)

    # Handle email input - extract username if full email provided, or append domain if just username
    email_input = @new_user.email.to_s.strip

    if email_input.include?("@")
      # If they provided a full email, use it as-is
      @new_user.email = email_input
    else
      # If they provided just username, append the domain
      @new_user.email = "#{email_input}@shepherdscollege.edu"
    end

    if @new_user.save
      flash[:notice] = "User #{@new_user.email} created successfully!"
      redirect_to users_path
    else
      @users = User.all.order(:email)
      flash.now[:alert] = "Error creating user: #{@new_user.errors.full_messages.join(', ')}"
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if params[:action_type] == "toggle_admin"
      if @user.admin?
        @user.remove_admin!
        flash[:notice] = "Removed admin privileges from #{@user.email}"
      else
        @user.make_admin!
        flash[:notice] = "Granted admin privileges to #{@user.email}"
      end
    end

    redirect_to users_path
  end

  def destroy
    if @user == Current.user
      flash[:alert] = "You cannot delete your own account."
    elsif @user.destroy
      flash[:notice] = "User #{@user.email} has been deleted."
    else
      flash[:alert] = "Error deleting user."
    end
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :is_admin)
  end

  def require_admin
    unless Current.user&.admin?
      redirect_to root_path, alert: "Admin access required."
    end
  end
end
