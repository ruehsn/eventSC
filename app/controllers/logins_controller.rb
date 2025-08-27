class LoginsController < ApplicationController
  skip_before_action :require_login, only: [ :show, :destroy, :create, :dev_login ]

  def show
    user = User.find_by_token_for(:magic_login, params[:token])
    if user.present?
      login(user)
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid or expired login link." unless flash[:alert].present? || flash[:notice].present?
      render "main/index"
    end
  end

  def create
    email = params[:email].to_s.strip.downcase

    unless email.end_with?("@shepherdscollege.edu")
      redirect_to root_path, alert: "Invalid email, reminder to use your work email address are allowed."
      return
    end

    user = User.find_by(email: email)

    # Check if user exists in the system
    if user.present?
      UserMailer.with(user: user).login.deliver_now
      redirect_to login_path, notice: "Check your email to login."
      nil
    else
      redirect_to root_path, alert: "You do not currently have access to this system. Please contact Heather to be added."
      nil
    end
  end

  # Development only route for quick login
  def dev_login
    if Rails.env.development? || Rails.env.test?
      email = params[:email] || "admin@shepherdscollege.edu"
      user = User.find_by(email: email)
      unless user.present?
        redirect_to root_path, alert: "User #{email} not found. Please contact Heather to be added."
        return
      end
      login(user)
      redirect_to root_path, notice: "Development login: Logged in as #{email}"
    else
      redirect_to root_path, alert: "Development login not available in this environment."
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "Logged out successfully."
  end
end
