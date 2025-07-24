# app/controllers/magic_sessions_controller.rb
class MagicSessionsController < ApplicationController
  before_action :set_user_by_token, only: %i[ show ]

  def show
    start_new_session_for @user

    redirect_to root_path
  end

  private

  def set_user_by_token
    @user = User.find_by_token_for(:signin, params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_magic_signup_path, alert: "Link is invalid or has expired."
  end
end