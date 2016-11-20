Rails.application.routes.draw do

  root 'home#index'

  resources :employees

  resources :vacancies

  resources :skills

  get '/employees/:id/get_matches', to: 'employees#get_matches'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
