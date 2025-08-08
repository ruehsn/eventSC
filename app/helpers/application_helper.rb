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
end
