Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        resources :registrations, only: %i[ create ]
        resources :sessions, only: %i[ create ] do
          post :refresh_token, on: :collection
        end
      end

      resources :users, only: %i[] do
        get :current, on: :collection
      end

      resources :movies, only: %i[] do
        get :popular, on: :collection
        get :upcoming, on: :collection
        get :top_rated, on: :collection
        get :now_playing, on: :collection
      end
    end
  end
end
