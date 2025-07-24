class MainController < ApplicationController
  skip_before_action :require_login, only: [:index]
  def index
    authenticate
  end
end