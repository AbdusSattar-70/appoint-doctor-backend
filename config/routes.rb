Rails.application.routes.draw do
  # mount Rswag::Ui::Engine => '/api-docs'
  # mount Rswag::Api::Engine => '/api-docs'
    devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }


  resources :users, only: [:index, :show, :destroy]
  resources :appointments, only: [:index, :show, :create, :update, :destroy]

end
