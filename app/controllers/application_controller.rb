class ApplicationController < ActionController::Base
  #before_filter :assure_profile!, :only => [:new, :edit, :create, :destroy]

  protect_from_forgery

  private

  def authenticate_admin!
    unless current_user.try(:admin?)
      flash[:alert] = "You must be logged in as an administrator to access this section"
      redirect_to root_url # halts request cycle
    end
  end

  def current_admin_user
    current_user.try(:admin?) ? current_user : nil
  end


  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User) && resource_or_scope.profile.blank?
      new_profile_path
    else
      super
    end
  end

  def assure_profile!
    return if((self.controller_name == 'sessions') || (self.controller_name.ends_with?('profiles') && self.action_name == 'create'))
    if user_signed_in? && current_user.profile.blank?
      redirect_to new_profile_path, :alert => 'Please create your Profile before continuing.' unless request.fullpath.include?(new_profile_path)
    end
  end
end
