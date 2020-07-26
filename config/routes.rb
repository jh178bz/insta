Rails.application.routes.draw do
  devise_for :users, controllers: { :omniauth_callbacks => "omniauth_callbacks" }

  root 'pages#home'

  get '/home' ,   to: 'pages#home'
  get '/terms',   to: 'pages#terms'
  get '/about',   to: 'pages#about'
  get '/contact', to: 'pages#contact'

  resources :users, only:[:show]
  resources :posts, only:[:new,:show,:create,:destroy]
end
