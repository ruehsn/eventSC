class LoginsController < ApplicationController
  skip_before_action :require_login, only: [:show, :destroy, :create]

  def show
    user = User.find_by_token_for(:magic_login, params[:token])
    login(user) if user.present?
    redirect_to root_path #, alert: "Invalid or expired login link." unless user
  end

  def create
    email = params[:email].to_s.strip.downcase
    unless email.ends_with?('@shepherdscollege.edu')
      redirect_to login_path, notice: "Invalid email, reminder to use your work email address are allowed." 
      return
    end

    user = User.find_or_create_by(email: params[:email])
    UserMailer.with(user: user).login.deliver_now if user.present?
    redirect_to root_path, notice: "Check your email to login."
  end

  def destroy
    logout
    redirect_to root_path, notice: "Logged out successfully."
  end
end