Zaglushka::Application.routes.draw do

  root :to => 'welcome#index'
  match 's/:id' => 'shorts#show', :as => 's_id'

  resources :users
  resources :cities
  if Rails.env.development?
    mount UserMailer::Preview => 'preview_email'
  end
end
