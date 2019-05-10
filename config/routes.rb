Rails.application.routes.draw do

  resources :contacts, except: [:show] do

    collection do
      get :autocomplete
    end

    resources :sales

    resources :phones, except: [:index, :destroy, :show] do
      member do
        get :cancel_edit
      end
      collection do
        get :cancel_new
      end
    end

    resources :notes do
      member do
        get :cancel_edit
      end
    end

    resources :followups do
      member do
        get :complete
      end
      collection do
        get :completed
      end
    end
  end

  resources :followups do

    member do
      get :complete
    end

    collection do
      get :completed
    end
  end

  resources :products do
    collection do
      get :autocomplete
    end
  end

  resources :sales, only: [:index, :new, :create, :update] do
    resources :sale_items, only: [:index, :create, :destroy]
  end

  resources :custom_fields do
    member do
      get :cancel_edit
    end
    resources :field_options, only: [:new, :create, :destroy] do
      post :save_sort, on: :collection
    end
  end

  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks' }

  get '/logout', to: 'home#logout'

  root 'home#index'

end
