class SearchController < ApplicationController
  def index
    @search = Search.new(params[:search])
  end

end
