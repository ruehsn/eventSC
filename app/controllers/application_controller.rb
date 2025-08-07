class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :require_login, unless: :skip_authentication?
  before_action :configure_local_csrf_fix, if: :local_environment_with_ssl_mismatch?

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
  
  def skip_authentication?
    # Skip authentication for MissionControl::Jobs
    Rails.logs.debug "Skipping authentication for jobs dashboard" if request.path.start_with?('/jobs')
    request.path.start_with?('/jobs')
  end
  
  def require_login
    authenticate
    unless Current.user
      redirect_to login_path, alert: "Please log in to continue."
    end
  end

  # Fix CSRF origin mismatch when running locally (development or staging on localhost)
  def local_environment_with_ssl_mismatch?
    # Apply fix when:
    # 1. Development mode with FORCE_STAGING, OR
    # 2. Staging environment running on localhost/127.0.0.1 (local testing)
    (Rails.env.development? && ENV['FORCE_STAGING'].present?) ||
    (Rails.env.staging? && (request.host.include?('localhost') || request.host.include?('127.0.0.1')))
  end

  def configure_local_csrf_fix
    # Temporarily disable origin check for local testing
    # This allows HTTP requests when the app expects HTTPS in staging
    request.env['action_controller.forgery_protection_origin_check'] = false
  end

end
