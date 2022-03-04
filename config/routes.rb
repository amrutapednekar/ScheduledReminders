Rails.application.routes.draw do
  resources :reminders
  root :to => 'sessions#welcome'
  get 'sessions/new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'welcome', to: 'sessions#welcome'
  get 'logout', to: 'sessions#logout'
  get 'authorized', to: 'sessions#page_requires_login'

  resources :users, only: [:new, :create]

  # To access session in rspec
    if Rails.env.test?
      namespace :test do
        resource :session, only: %i[create]
      end
    end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
