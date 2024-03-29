require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'

  # API namespace
  namespace :api do
    resources :todos, only: [] do
      collection do
        get 'conflicts', to: 'todos#conflicts'
      end
    end
    post '/todos', to: 'todos#create'
  end

  resources :todos, only: [] do
    member do
      post 'attachments', to: 'attachments#create'
    end
  end
end
