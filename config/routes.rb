Rails.application.routes.draw do
  root "boards#new"
  
  resources :boards, only: [:index, :show, :new, :create]
end
