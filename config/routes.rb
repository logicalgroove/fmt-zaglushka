Zaglushka::Application.routes.draw do

  #root :to => 'welcome#index'
  root :to => 'welcome#travels'

  get '75daysofeurope', to: 'welcome#travels'

  match 's/:id' => 'shorts#show', :as => 's_id'

  resources :users do
    get :delete_city
    get :shared_to
  end

  resources :cities, :only => [:create]

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
