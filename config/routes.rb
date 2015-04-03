Cambium::Engine.routes.draw do

  namespace :admin do
    get '/' => 'dashboard#index', :as => :root
    get 'dashboard' => 'dashboard#show', :as => :dashboard
  end

end
