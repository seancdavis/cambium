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

  if ActiveRecord::Base.connection.data_source_exists?('cambium_pages')
    Cambium::Page.published.each do |page|
      template = page.template
      next if template.nil? || page.page_path.blank?
      begin
        if template.respond_to?(:controller) && template.respond_to?(:action)
          get page.page_path => "/#{template.controller}##{template.action}"
        else
          get page.page_path => 'pages#show'
        end
      rescue
      end
    end
  end

end
