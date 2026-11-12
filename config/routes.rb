Rails.application.routes.draw do
  # resources :workdays
  # resources :workmonths
  # resources :workplaces
  # resources :workers
  # resources :companies
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#index"

  # TOUHOU ROUTES
  # New administrative user
  get "/touhou/new", to: "pages#new_user", as: "new_user"
  post "/touhou/users", to: "pages#create_user", as: "create_user"

  # main page + current day check-in/check-out
  get "/touhou", to: "pages#thmain", as: "thmain"

  # workers routes
  get "/touhou/workers", to: "workers#index", as: "workers_main"
  get "/touhou/workers/new", to: "workers#new", as: "new_worker"
  get "/touhou/workers/qr/:access_token", to: "workers#show_qr", as: "worker_qr"
  post "/touhou/workers/regenerate_token/:access_token", to: "workers#regenerate_token", as: "regenerate_token"
  get "/touhou/workers/:access_token", to: "workers#show", as: "worker"
  post "/touhou/workers", to: "workers#create", as: "create_worker"
  get "/touhou/workers/:access_token/edit", to: "workers#edit", as: "edit_worker"
  patch "/touhou/workers/:access_token", to: "workers#update", as: "update_worker"
  delete "/touhou/workers/:access_token", to: "workers#destroy", as: "destroy_worker"

  # companies routes
  get "/touhou/companies", to: "companies#index", as: "companies_main"
  get "/touhou/companies/new", to: "companies#new", as: "new_company"
  get "/touhou/companies/:id", to: "companies#show", as: "company"
  post "/touhou/companies", to: "companies#create", as: "create_company"
  get "/touhou/companies/:id/edit", to: "companies#edit", as: "edit_company"
  patch "/touhou/companies/:id", to: "companies#update", as: "update_company"
  delete "/touhou/companies/:id", to: "companies#destroy", as: "destroy_company"

  # workplaces routes
  get "/touhou/workplaces", to: "workplaces#index", as: "workplaces_main"
  get "/touhou/workplaces/new", to: "workplaces#new", as: "new_workplace" # todo
  get "/touhou/workplaces/:id", to: "workplaces#show", as: "workplace" # todo
  post "/touhou/workplaces", to: "workplaces#create", as: "create_workplace" # todo
  get "/touhou/workplaces/:id/edit", to: "workplaces#edit", as: "edit_workplace" # todo
  patch "/touhou/workplaces/:id", to: "workplaces#update", as: "update_workplace" # todo
  delete "/touhou/workplaces/:id", to: "workplaces#destroy", as: "destroy_workplace" # todo

  # workdays routes
  get "/touhou/workdays", to: "workdays#index", as: "workdays_main"
  get "/touhou/workdays/new", to: "workdays#new", as: "workdays_new" # todo
  get "/touhou/workdays/:id", to: "workdays#show", as: "workday"
  post "/touhou/workdays/new", to: "workdays#create", as: "workdays_create" # todo
  get "/touhou/workdays/check/:access_token", to: "workdays#check", as: "check"
  post "/touhou/workdays/check/:access_token", to: "workdays#checkin", as: "checkin"
  patch "/touhou/workdays/check/:access_token", to: "workdays#checkout", as: "checkout"
  get "/touhou/workdays/:id/edit", to: "workdays#edit", as: "workday_edit"
  patch "/touhou/workdays/:id", to: "workdays#update", as: "workday_update"
  delete "/touhou/workdays/:id", to: "workdays#destroy", as: "workday_destroy"

  # workmonths routes
  get "/touhou/workmonths", to: "workmonths#index", as: "workmonths_main"
end
