require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'

  # API namespace
  namespace :api do
    # Merged the new route from the new code with the existing routes
    post '/folders/error', to: 'folders#handle_folder_creation_error'
    post '/folders/validate', to: 'folders#validate' # Existing route from the old code

    resources :todos, only: [] do
      collection do
        get 'conflicts', to: 'todos#conflicts'
      end
      member do
        get 'deletion-error', to: 'todos#handle_deletion_error'
        post 'cancel-deletion', to: 'todos#cancel_deletion'
      end
    end
    # These routes are the same in both the new and existing code, so they are included once
    delete '/todos/:id', to: 'todos#destroy'
    post '/todos', to: 'todos#create'
  end

  # This section is the same in both the new and existing code, so it remains unchanged
  resources :todos, only: [] do
    member do
      post 'attachments', to: 'attachments#create'
    end
  end
end
