Rails.application.routes.draw do
  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "tasks#index"
  patch "/tasks/:id/task_complete", to: "tasks#mark_complete"
  get "/tasks/search/:search", to: "tasks#search_tasks", as: "search_tasks"
end
