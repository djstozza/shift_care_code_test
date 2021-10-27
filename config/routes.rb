Rails.application.routes.draw do
  devise_for :admins
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'application#index'

  namespace :api do
    devise_scope :admin do
      resources :sessions, only: %i[create] do
        put :update, on: :collection
        patch :update, on: :collection
      end

      resources :clients, only: %i[index create update]
      resources :plumbers, only: %i[index create update]
      resources :jobs, only: %i[index create show update] do
        resource :complete, only: %i[create], module: :jobs
      end
    end
  end

  # Catch all for HTML 5 history routing. This must be the last route.
  get '/*path', to: 'application#index', format: false
end
