Rails.application.routes.draw do
  resources :instances
  resources :charges
  devise_for :users
  mount StripeEvent::Engine => '/events'
  root 'home#index'
end