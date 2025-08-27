class JobsController < ApplicationController
  # Skip our app's authentication for the jobs dashboard
  skip_before_action :require_login

  def index
    # In development, we'll proxy to MissionControl::Jobs without authentication
    if Rails.env.development?
      redirect_to "/jobs/queues", allow_other_host: false
    else
      # In production, you might want to add admin authentication here
      redirect_to "/jobs/queues", allow_other_host: false
    end
  end
end
