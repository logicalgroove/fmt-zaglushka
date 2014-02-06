Zaglushka::Application.routes.draw do

  root :to => 'welcome#index'
  match 's/:id' => 'shorts#show', :as => 's_id'
  match '/404' => 'errors#not_found'
  match '/422' => 'errors#server_error'
  match '/500' => 'errors#server_error'
  resources :users
  resources :cities
  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
  end
  if Rails.env.production?
    get "/404", :to => "exceptions#show"
    get "/422", :to => "exceptions#show"
    get "/500", :to => "exceptions#show"
  end
  if Rails.env.development?
    mount UserMailer::Preview => 'preview_email'
  end
end
