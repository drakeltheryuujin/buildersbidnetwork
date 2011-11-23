class SearchController < ApplicationController
  def index
    case params[:section]
	    when :contractors.to_s
        view = :contractors
	      @search = ContractorProfile.search(params[:q])
	    when :developers.to_s
        view = :developers
	      @search = DeveloperProfile.search(params[:q])
	    else
        view = :projects
	      @search = Project.search(params[:q])
	  end
    @search_results = @search.all
    render :action => view
  end

end
