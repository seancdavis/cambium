Rails.application.routes.draw do

  # --- Cambium's Routes ---
  #
  # The following are Cambium's default routes. Feel free to
  # customize (or delete) these to fit your needs.
  #
  # ------------------------------------------ Users (Devise)
  #
  # Learn more about Devise at https://github.com/plataformatec/devise
  #
  devise_for :users, :skip => [:sessions, :registrations]
  devise_scope :user do
    get '/login' => 'devise/sessions#new', :as => :new_user_session
    post '/login' => 'devise/sessions#create', :as => :user_session
    get '/logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  #
  # ------------------------------------------ Admin
  #
  # Cambium already namespaces all its own routes, so it's
  # best to just mount it at the root. This is the base
  # setup if you are using Cambium's CMS
  #
  mount Cambium::Engine => '/'
  #
  # ------------------------------------------ JSON
  #
  # If you plan to use any public json routes, it's good to
  # nest them in their own scope. We use a scope instead of
  # a namespace because a controller action can have routes
  # to it in different formats, so namespacing is
  # unecessary.
  #
  # scope 'json' do
  #   'users' => 'users#index'
  # end
  #
  # ------------------------------------------ Public
  #
  # After we define all namespaced routes, we can move on to
  # those routes that are not namespaced.
  #
  # resources :users
  #
  # ------------------------------------------ Home Page
  #
  # This is your application's home page. Feel free to
  # delete the home controller and change this if you want a
  # different home page.
  #
  root :to => 'home#index'

end
