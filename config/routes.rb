Cambium::Engine.routes.draw do

  get 'admin' => 'admin#dashboard', :as => :admin

end
