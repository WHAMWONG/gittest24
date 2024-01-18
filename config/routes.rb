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
        post '/folders/validate', to: 'folders#validate'
        get 'conflicts', to: 'todos#conflicts'
        resources :folders, only: [:create]
      end
      member do
        get 'deletion-error', to: 'todos#handle_deletion_error'
        post 'cancel-deletion', to: 'todos#cancel_deletion'
      end
    end
    delete '/todos/:id', to: 'todos#destroy'
    post '/todos', to: 'todos#create'
    post '/folders/cancel', to: 'folders#cancel_creation'
  end

  resources :attachments, only: [:create]

  resources :todos, only: [] do
    member do
      post 'attachments', to: 'attachments#create'
    end
  end
end
