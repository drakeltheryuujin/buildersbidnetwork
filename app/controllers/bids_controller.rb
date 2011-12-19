class BidsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_project_and_bid, :only => [:show, :update, :edit]
  before_filter :get_project, :only => [:new, :create]
  before_filter :verify_bidding_period!, :only => [:new, :create, :edit, :update]
  before_filter :check_may_modify!, :only => [:update, :edit]
  
  def show
  end
  
  def edit
  end
  
  def new
    @bid = Bid.new(:project => @project)
    @project.line_items.each do |line_item|
      @bid.line_item_bids.build :line_item => line_item
    end
  end
  
  def create
    @bid = @project.bids.new(params[:bid].merge(:user => current_user))
    update_bid_state! params
    
    if @bid.save
      redirect_to(project_path(@project), :notice => 'Bid was successfully created.')
    else
      render :action => "new"
    end
  end
  
  def update
    @bid.user_id = current_user.id
    update_bid_state! params
    
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

  def get_project
    @project = Project.find(params[:project_id])
  end

  def check_may_modify!
    redirect_to(bid_path(@bid), :alert => "Access denied.") unless @bid.may_modify? current_user
  end

  def verify_bidding_period!
    redirect_to(project_path(@project), :alert => "Bids accepted for #{@project.name} between #{@project.bidding_start.to_formatted_s(:short)} and #{@project.bidding_end.to_formatted_s(:short)}.") unless @project.bidding_period?
  end

  def update_bid_state!(params)
    if params[:publish] 
      @bid.publish 
    elsif params[:cancel] 
      @bid.cancel
    end
  end
end
