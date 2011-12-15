Ypn::Application.routes.draw do

  ActiveAdmin.routes(self)

  resources :projects do
    resources :bids
    resources :project_documents
    member do
	    get 'review'
	    post 'contact_creator'
	  end
    collection do
	    get 'track_projects'
	    get 'track_bids'
	  end
  end

  resources :profiles do
    member do
	    get 'projects'
	    post 'contact_owner'
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

  devise_for :users

  resources :messages

  resources :conversations
  
  resources :notifications do
    collection do
      put 'update_all'
    end
  end

  resources :credits, :only => [:index, :new, :create]
  
  resources :search, :only => [:index]

  match 'home/:page' => 'home#show', :as => :content_page
  get "home/index"

  root :to => "home#index"
end
