Rails.application.routes.draw do
  resources :avatars
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :tasks
  resources :starred_tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "tasks#index"

  patch "/users/edit/avatar/:id", to: "application#change_avatar"
  get "/tasks/date/:date", to: "tasks#get_tasks_by_date", as: "tasks_by_date"
  patch "/tasks/:id/task_complete", to: "tasks#mark_complete"

  # collab
  get "/collab", to: "tasks#collab_requests", as: "collab_request"
  patch "/collab/accept/:task_id", to: "collaborators#accept_request", as: "accept_request"
  patch "/collab/reject/:task_id", to: "collaborators#reject_request", as: "reject_request"


  # starred tasks
  get "/starred_tasks/", to: "starred_tasks#index"
  post "/starred_tasks/:id", to: "starred_tasks#add", as:"add_to_starred"
  delete "/starred_tasks/:id", to: "starred_tasks#destroy", as:"remove_starred"

end
