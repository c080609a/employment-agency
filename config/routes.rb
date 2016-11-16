Rails.application.routes.draw do

  root 'home#index'

  resources :employees

  resources :vacancies

  resources :skills

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
