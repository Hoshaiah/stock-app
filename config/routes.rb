Rails.application.routes.draw do
  devise_for :users
  root to: "transactions#new", as: "home"
  resources :transactions, except: [:new]
  resources :stocks
end
