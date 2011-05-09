Wassembly::Application.routes.draw do
  resources :propositions do
    collection do
      get :latest
      get :voting
    end
    resources :votes
    resources :comments
  end

  match 'help/:permalink' => 'pages#show', :as => :static
  resources :ratings
  resources :users
  resources :ratings
  resources :user_sessions
  resources :user_verifications
  resources :identity_verifications
  resources :pages
  resources :announcements do
    collection do
      get :hide
    end
  end

  resources :logged_exceptions do
    collection do
      delete :destroy_all
    end
  end
  
  resources :comments
  resources :votes
  
  root :to => 'propositions#voting'
  match 'admin' => 'admin#index', :as => :admin
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match ':controller/:action.:format' => '#index'
end