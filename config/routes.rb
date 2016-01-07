Cambium::Engine.routes.draw do

  namespace :admin do
    get '/' => 'dashboard#index', :as => :root
    get 'dashboard' => 'dashboard#show', :as => :dashboard
    get 'search' => 'search#index', :as => :search
    resources :pages, :param => :slug
    resources :users
  end

end
