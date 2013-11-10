Zaglushka::Application.routes.draw do

  root :to => 'welcome#index'

  resources :users do
    member do
      put :add_city
    end

  end
  resources :cities

end
