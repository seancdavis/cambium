Cambium::Engine.routes.draw do

  namespace :admin do
    get '/' => 'dashboard#index', :as => :root
    get 'dashboard' => 'dashboard#show', :as => :dashboard
    get 'search' => 'search#index', :as => :search
    resources :documents
    resources :pages, :param => :slug
    resources :users
    resources :settings
  end

  if ActiveRecord::Base.connection.table_exists?('cambium_pages')
    Cambium::Page.published.each do |page|
      get page.page_path => 'pages#show' unless page.page_path.blank?
    end
  end

end
