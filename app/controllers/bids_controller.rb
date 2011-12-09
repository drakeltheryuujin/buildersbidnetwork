class BidsController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @bid = Bid.find(params[:id])
    @project = @bid.project
  end
  
  def edit
    @bid = Bid.find(params[:id])
    @project = @bid.project
  end
  
  def new
    @project = Project.find(params[:project_id])
    @bid = Bid.new(:project => @project)
    @project.line_items.each do |line_item|
      @bid.line_item_bids.build :line_item => line_item
    end
  end
  
  def create
    @project = Project.find(params[:project_id])
    @bid = @project.bids.new(params[:bid].merge(:user => current_user))
    @bid_purchase = BidPurchaseDebit.new :user => current_user, :bid => @bid, :value => - @project.credit_value
    
    if @bid_purchase.save
      current_user.update_attribute(:credits, current_user.credit_adjustments.sum(:value)) 
      redirect_to(project_path(@project), :notice => 'Bid was successfully created.')
    else
      render :action => "new"
    end
  end
  
  def update
    @bid = Bid.find(params[:id])
    
    @bid.user_id = current_user.id
    
    if @bid.update_attributes(params[:bid])
      redirect_to(project_path(@bid.project), :notice => 'Bid was successfully updated.')
    else
      render :action => "edit"
    end
  end
end
