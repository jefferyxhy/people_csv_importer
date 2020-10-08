# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "people#index"
  
  resources :people do
    post '/batch-create', to: 'people#batch_create', on: :collection
  end
end
