Rails.application.routes.draw do
  root "boards#new"
  
  resources :boards
end
