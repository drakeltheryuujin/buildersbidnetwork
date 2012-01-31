class HomeController < ApplicationController
  def index
    if user_signed_in?
      render :action => 'dashboard'
    else
      render :action => 'index'
    end
  end

  def show
    render :action => params[:page]
  end
end
