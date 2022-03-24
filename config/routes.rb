Rails.application.routes.draw do
  devise_for :admins
  get "admin", to: "admins#admin_home", as: "admin_home"
  get "admin/transactions", to: "admins#transactions", as: "transactions_all"
  get "admin/users", to: "users#index", as: "users_all"
  post "admin/users", to: "users#create", as: "create_user"
  delete "admin/users/:id", to: "users#destroy", as: "destroy_user"
  get "admin/users/:id/edit", to:"users#edit", as: "edit_user"
  patch "admin/users/:id/edit", to:"users#update", as: "update_user"
  get "admin/users/new", to: "users#new", as: "new_users"

  devise_for :users
  root to: "transactions#new", as: "home"
  resources :transactions, except: [:new]
  resources :stocks
end
