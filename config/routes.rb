Zaglushka::Application.routes.draw do

  root :to => 'welcome#index'

  resources :users
  resources :cities
  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
  end

  if Rails.env.development?
    mount UserMailer::Preview => 'preview_email'
  end
end
