OlacNlp::Application.routes.draw do
  resources :nlps 
  
#  authenticated :user do
#    root :to => 'home#index'
#  end
 
  root :to => "home#index"
  devise_for :users
  resources :users

  get "/nlps/random/:language" => "nlps#random_by_language"
  get "/nlps/random/:language/:id" => "nlps#random_by_language"
  get "/nlps/random/:language/:id/:interest_id" => "nlps#random_by_language"
  
  match 'review' => 'review#index', :via => :get
  match 'contact' => 'contact#new', :as => 'contact', :via => :get
  match 'contact' => 'contact#create', :as => 'contact', :via => :post
  
  match 'credits' => "home#credits"
  match 'about' => "home#about"

end