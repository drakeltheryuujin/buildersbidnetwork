class SearchController < ApplicationController
  helper :all

  def index
    #@conversations = Kaminari.paginate_array(@mailbox.inbox).page(params[:page]).per(9)
    #Kaminari.paginate_array(my_array_object).page(params[:page]).per(10)
    #@search = Search.new(params[:search])
    #@search = Kaminari.paginate_array(Search.new(params[:search]).results).page(params[:page]).per(9)
    @params = params[:search]
    if params[:page].blank?
      @params['page'] = 1
    else
      @params['page'] = params[:page]
    end
    
    @search = Search.new(@params)
  end

end
