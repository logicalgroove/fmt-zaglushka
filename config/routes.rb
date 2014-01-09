Zaglushka::Application.routes.draw do

  root :to => 'welcome#index'

  resources :users
  resources :cities
  if Rails.env.development?
    mount UserMailer::Preview => 'preview_email'
  end
end
