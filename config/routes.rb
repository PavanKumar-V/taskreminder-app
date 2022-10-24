Rails.application.routes.draw do
  devise_for :users
  resources :tasks
  resources :starred_tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "tasks#index"
  get "/tasks/date/:date", to: "tasks#get_tasks_by_date", as: "tasks_by_date"
  patch "/tasks/:id/task_complete", to: "tasks#mark_complete"
  # get "/tasks/search/:search", to: "tasks#search_tasks", as: "search_tasks"


  # starred tasks
  get "/starred_tasks/", to: "starred_tasks#index"
  post "/starred_tasks/:id", to: "starred_tasks#add", as:"add_to_starred"
  delete "/starred_tasks/:id", to: "starred_tasks#destroy", as:"remove_starred"

end
