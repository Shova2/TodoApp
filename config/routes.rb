Rails.application.routes.draw do
  #mapping get/todo  post/todo put/todo delete/todo to Todoscontroller#index TodosController#create Todoscontroller#update Todoscontroller#destroys
  # resources :todos, only: [:index, :create, :update, :destroy]
  resources :users do
    resources :todo_lists do
      resources :todos
    end
  end
end
