
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
        get 'conflicts', on: :collection
        resources :folders, only: [:create]
      end
      member do
        get 'handle_deletion_error', on: :member, path: 'deletion-error'
        post 'cancel_deletion', on: :member, path: 'cancel-deletion'
      end
    end
    resources :todos, only: [:create, :destroy]
    post '/folders/cancel', to: 'folders#cancel_creation'
  end

  resources :attachments, only: [:create] do
    member do
      post 'create', on: :member
    end
  end
end
