Rails.application.routes.draw do
    devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }


  resources :users, only: [:index, :show, :destroy]
  resources :appointments, only: [:index, :show, :create, :update, :destroy]

end
