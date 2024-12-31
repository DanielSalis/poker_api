Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  resources :players, only: [ :index, :create, :destroy ]

  resources :player_games

  resources :games, path: "rooms" do
    member do
      post :join
      delete :leave
      post :start
      post :perform_action, path: "action"
      post :next_phase, path: "next-phase"
      post :end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
