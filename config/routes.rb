Ypn::Application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :projects do
    resources :bids do
      member do 
        post 'award'
        post 'accept'
      end 
    end
    resources :project_documents
    member do
	    get 'review'
	    post 'contact_creator'
	    post 'update_cover_photo'
      get 'manage_access'
	  end
  end

  resources :profiles do
    member do
	    get 'projects'
	    post 'contact_owner'
	    post 'invite'
	  end
    collection do
	    get 'settings'
    end
  end

  resources :developer_profiles do
    member do
	    get 'projects'
	    get 'contact_owner'
	  end
    collection do
	    get 'settings'
    end
  end

  resources :contractor_profiles do
    member do
	    get 'projects'
	    get 'contact_owner'
	  end
    collection do
	    get 'settings'
    end
  end

  devise_for :users, :controllers => { :invitations => 'users/invitations' }


  resources :messages

  resources :conversations
  
  resources :notifications do
    collection do
      put 'update_all'
    end
  end

  resources :credits, :only => [:index, :new, :create, :show] do
    collection do
      get 'history'
    end
  end
  
  resources :subscriptions, :only => [:index, :new, :create, :show] do
    collection do
      get 'status'
      get 'cancel'
    end
  end


  resources :search, :only => [:index]

  resources :activity, :only => [:index] do
    collection do
      get 'private'
    end
  end

  match 'home/:page' => 'home#show', :as => :content_page
  get "home/index"

  root :to => "home#index"
end
