Rails.application.routes.draw do
  require 'sidekiq/web'

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  root 'posts#index'
  get 'about', to: 'pages#about', as: 'about'

  devise_for :admins

  controller :posts do
    get 'map', action: :map
  end
  
  resources :posts, path: "/", except: [:new, :edit]
end
