class BidsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_project_and_bid, :only => [:show, :update, :edit]
  before_filter :check_may_modify!, :only => [:update, :edit]
  
  def show
  end
  
  def edit
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
    @bid.state = (@bid.state.blank? ? :draft : (params[:publish] ? :published : :draft))
    @bid_purchase = BidPurchaseDebit.new :user => current_user, :bid => @bid, :value => - @project.credit_value
    
    if @bid_purchase.save
      current_user.update_attribute(:credits, current_user.credit_adjustments.sum(:value)) 
      redirect_to(project_path(@project), :notice => 'Bid was successfully created.')
    else
      render :action => "new"
    end
  end
  
  def update
    @bid.user_id = current_user.id
    @bid.state = (@bid.state.blank? ? :draft : (params[:publish] ? :published : :draft))
    
    if @bid.update_attributes(params[:bid])
      redirect_to(project_path(@bid.project), :notice => 'Bid was successfully updated.')
    else
      render :action => "edit"
    end
  end

  private

  def get_project_and_bid
    @bid = Bid.find(params[:id])
    @project = @bid.project
  end

  def check_may_modify!
    redirect_to(bid_path(@bid), :alert => "Access denied.") unless @bid.may_modify? current_user
  end
end
