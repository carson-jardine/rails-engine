Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get '/revenue', to: 'invoices/revenue#revenue_by_date_range'

      namespace :merchants do
        get '/most_revenue', to: 'business_intel#most_revenue'
        get '/most_items', to: 'business_intel#most_items'
        get '/:merchant_id/items', to: 'items#index'
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end

      namespace :items do
        get '/:item_id/merchants', to: 'merchants#index'
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end

      resources :items

      resources :merchants
    end
  end
end
