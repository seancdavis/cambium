Cambium::Engine.routes.draw do

  namespace :admin do
    get '/' => 'dashboard#index', :as => :root
    get 'dashboard' => 'dashboard#show', :as => :dashboard
    get 'search' => 'search#index', :as => :search
    resources :documents
    resources :pages, :param => :slug
    resources :users
  end

  Cambium::Page.published.each do |page|
    get page.slug => 'pages#show'
  end

end
