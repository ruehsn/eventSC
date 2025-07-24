module ApplicationHelper
  def current_user
    Current.user
  end

  def logged_in?
    current_user.present?
  end

end
