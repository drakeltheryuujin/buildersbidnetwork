class ErrorsController < ApplicationController
  def routing
    respond_to do |type| 
        type.html { render :template => "errors/error_404", :status => 404, :layout => 'application' } 
        type.all  { render :nothing => true, :status => 404 } 
    end
    true
  end
end