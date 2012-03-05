class SearchController < ApplicationController
  helper :all

  def index
    @search = Search.new(params[:search])
  end

end
