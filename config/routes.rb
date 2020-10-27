Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :admin do
        resources :users, param: :identifier do
          resources :sessions, param: :identifier
          resources :linked_accounts, param: :identifier
        end
      end

      namespace :magic_link do
        resources :signups, only: [:create]
        resources :sessions, only: [:create] do
          post :request_link, on: :collection
        end
      end

      resource :current_session, only: [:show, :destroy]
    end
  end

  root to: "home#index"
end
