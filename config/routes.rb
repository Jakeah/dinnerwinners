Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :welcome do
    collection do
      post :login
      post :logout
      get  :admin_dashboard
    end
  end

  match 'logout' => 'welcome#logout', :as => :logout, via: [:get, :post]
end
