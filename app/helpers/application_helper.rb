module ApplicationHelper
  def current_user
    Current.user
  end

  def logged_in?
    current_user.present?
  end

  def admin_user?
    current_user&.admin?
  end

  def development_login_enabled?
    Rails.env.development?
  end

  def skip_magic_link_emails?
    Rails.env.development? && 
    Rails.application.config.respond_to?(:skip_magic_link_emails) && 
    Rails.application.config.skip_magic_link_emails
  end
end
