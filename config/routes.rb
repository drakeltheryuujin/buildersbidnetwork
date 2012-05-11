Ypn::Application.routes.draw do

  # FIXME devise's omniauth only supports one omniauthable model.  May need to invert the inheritence on User/AdminUser.
  #ActiveAdmin.routes(self)
  #devise_for :admin_users, ActiveAdmin::Devise.config

  resources :projects do
    resources :bids do
      resources :bid_documents
      member do 
        post 'award'
        post 'revoke'
        post 'accept'
      end 
    end
    resources :project_documents
    member do
	    get 'review'
	    post 'contact_creator'
	    post 'update_cover_photo'
      get 'manage_access'
      delete 'revoke_access'
      post 'invite_by_email'
      post 'invite_by_linkedin'
	  end
  end

  resources :profiles do
    resources :profile_documents
    member do
	    get 'projects'
      get 'documents'
	    post 'contact_owner'
	    post 'invite'
	    post 'add_cover_photo'
	  end
    collection do
	    get 'settings'
    end
  end

  resources :developer_profiles do
    resources :profile_documents
    member do
	    get 'projects'
	    get 'contact_owner'
	  end
    collection do
	    get 'settings'
    end
  end

  resources :contractor_profiles do
    resources :profile_documents
    member do
	    get 'projects'
	    get 'contact_owner'
	  end
    collection do
	    get 'settings'
    end
  end

  match '/users/auth/:service/callback' => 'authentications#create' 
  resources :authentications, :only => [:index, :create, :destroy]

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

  #match '*a', :to => 'errors#routing'  
end
