Rails.application.routes.draw do
    devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

get '/users/doctors/:id', to: 'users#show_doctor'
  resources :users, only: [:index, :show, :destroy]
  resources :appointments, only: [:index, :show, :create, :update, :destroy]

end
