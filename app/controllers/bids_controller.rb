class BidsController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @bid = Bid.find(params[:id])
  end
  
  def new
    @project = Project.find(params[:project_id])
    @bid = Bid.new(:project => @project)
    @project.line_items.each do |line_item|
      @bid.line_item_bids.build :line_item => line_item
    end
    #3.times do
    #  @bid.line_item_bids.build
    #end
  end
  
  def create
    @project = Project.find(params[:project_id])
    #@bid = @project.bids.create(params[:bid])
    @bid = @project.bids.new(params[:bid])
    #@bid = Bid.new(params[:bid])
    #@bid.project = project
    
    @bid.user_id = current_user.id
    
    if @bid.save
      #redirect_to([@project, @bid], :notice => 'Bid was successfully created.')
      redirect_to(project_path(@project), :notice => 'Bid was successfully created.')
    else
      render :action => "new"
    end
  end
end
