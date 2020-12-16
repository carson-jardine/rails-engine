Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do

      namespace :merchants do
        get '/:merchant_id/items', to: 'items#index'
      end
      
      namespace :items do
        get '/:item_id/merchants', to: 'merchants#index'
      end

      resources :items

      resources :merchants
    end
  end
end
