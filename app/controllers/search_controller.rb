class SearchController < ApplicationController
  helper :all

  def index
    params[:search] ||= {}
    params[:search][:page] = params[:page]
    @search = Search.new(params[:search])
  end

end
