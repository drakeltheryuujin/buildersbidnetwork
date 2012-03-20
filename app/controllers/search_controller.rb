class SearchController < ApplicationController
  helper :all

  def index
    @params = params[:search]
    if params[:page].blank?
      @params['page'] = 1
    else
      @params['page'] = params[:page]
    end
    
    @search = Search.new(@params)
  end

end
