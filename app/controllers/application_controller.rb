class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # def authenticate
  #   Current.user ||= User.find_by(id: session[:user_id]) 
  # end

  # def login(user)
  #   Current.user = user
  #   session[:user_id] = user.id
  # end
  
  # def logout
  #   session[:user_id] = nil
  #   Current.user = nil
  # end

end
