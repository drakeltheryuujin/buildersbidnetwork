class ApplicationController < ActionController::Base
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
end
