Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  get 'applies/index1' => 'applies#index1'
  get 'applies/index2' => 'applies#index2'
  
  resources :bases
  resources :users do
    resources :applies
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month' 
      patch 'attendances/update_one_month'
    end
    collection do
      post 'import'
      get 'index_attendance'
    end 
    resources :attendances, only: [:update] do
        get 'edit_overtime_request'
        patch 'update_overtime_request'
        get 'edit_month_approval'
        patch 'update_month_approval'
    end
  end
end
