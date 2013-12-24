Zaglushka::Application.routes.draw do

  root :to => 'welcome#index'

  resources :users
  resources :cities

end
