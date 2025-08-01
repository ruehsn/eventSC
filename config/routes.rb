Rails.application.routes.draw do
  get 'survey', to: 'survey#index'
  post 'survey/submit', to: 'survey#submit'
  resources :students do
    member do
      get 'event_signup'
      post 'submit_event_options'
      post 'send_parent_email_now'
    end
  end
  resources :vehicles
  resources :event_options
  resources :events do
    member do
      get 'cash_office'
      get 'student_cash'
    end
  end
  resources :living_areas
  resources :advisors do
    member do
      get :students
    end
  end
  resources :survey, only: [:index, :show]
  resource :login, only: [:show, :destroy, :create] do
    # Development only route
    get :dev_login, on: :collection if Rails.env.development?
  end
  
  # Admin user management
  resources :users, only: [:index, :show, :create, :update, :destroy]
  
  root "main#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Mission Control Jobs dashboard
  mount MissionControl::Jobs::Engine, at: "/jobs"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "main#index"
end
