class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :require_login

  def authenticate
    Current.user ||= User.find_by(id: session[:user_id]) 
  end

  def login(user)
    user.touch :last_sign_in_at
    Current.user      = user
    session[:user_id] = user.id
  end
  
  def logout
    session[:user_id] = nil
    Current.user      = nil
  end

  private
  def require_login
    authenticate
    unless Current.user
      redirect_to login_path, alert: "Please log in to continue."
    end
  end

end
