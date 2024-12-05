Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
    resources :todo_lists do
      resources :todos
      resources :collaborators, only: [:index, :create, :destroy] 
  end
end
