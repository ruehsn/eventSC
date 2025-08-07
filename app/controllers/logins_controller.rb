class LoginsController < ApplicationController
  skip_before_action :require_login, only: [:show, :destroy, :create, :dev_login]

  def show
    user = User.find_by_token_for(:magic_login, params[:token])
    if user.present?
      login(user)
      redirect_to root_path
    else
      redirect_to root_path, alert: "Invalid or expired login link."
    end
  end

  def create
    email = params[:email].to_s.strip.downcase
    
    # Development bypass - directly login without magic link
    if Rails.env.development? && params[:dev_bypass] == 'true'
      user = User.find_by(email: email)
      unless user.present?
        redirect_to login_path, alert: "You do not currently have access to this system. Please contact Heather to be added."
        return
      end
      login(user)
      redirect_to root_path, notice: "Development bypass: Logged in as #{email}"
      return
    end
    
    unless email.ends_with?('@shepherdscollege.edu')
      redirect_to login_path, notice: "Invalid email, reminder to use your work email address are allowed." 
      return
    end

    user = User.find_by(email: email)
    
    # Check if user exists in the system
    unless user.present?
      redirect_to login_path, alert: "You do not currently have access to this system. Please contact Heather to be added."
      return
    else
      UserMailer.with(user: user).login.deliver_now if user.present?
      redirect_to root_path, notice: "Check your email to login."
      return
    end
    
    # In development, provide option to skip email sending
    if Rails.env.development? && Rails.application.config.respond_to?(:skip_magic_link_emails) && Rails.application.config.skip_magic_link_emails
      login(user)
      redirect_to root_path, notice: "Development: Logged in directly as #{email}"
    else
      UserMailer.with(user: user).login.deliver_now
      redirect_to root_path, notice: "Check your email to login."
    end
  end

  # Development only route for quick login
  def dev_login
    if Rails.env.development?
      email = params[:email] || 'admin@shepherdscollege.edu'
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