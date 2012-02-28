class BidsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_project_and_bid, :only => [:show, :update, :edit, :award, :accept]
  before_filter :get_project, :only => [:new, :create]
  before_filter :verify_bidding_period!, :only => [:new, :create, :edit, :update]
  before_filter :check_may_modify!, :only => [:update, :edit]
  
  def show
  end
  
  def new
    @bid = Bid.new(:project => @project)
    @project.line_items.each do |line_item|
      @bid.line_item_bids.build :line_item => line_item
    end
  end
  
  def edit
    @project.line_items.each do |line_item|
      unless @bid.line_item_bids.detect { |lib| lib.line_item_id == line_item.id }
        @bid.line_item_bids.build :line_item => line_item
      end
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

  def award
    @bid.award!
    winner = @bid.user
    sender_name = current_user.name
    body = params[:message_body] || sender_name + " has awarded your bid for #{@project.name}."
    subject = "You've been awarded #{@project.name}"
    current_user.send_message_with_object_and_type([winner], body, subject, @bid, :project_award_message)

    respond_to do |format|
      format.html { redirect_to(project_bid_path(@project, @bid), :notice => 'Bid Awarded') }
      format.text { render :text => "Bid Awarded" }
    end
  end

  def accept
    @bid.accept!
    sender_name = current_user.name
    body = params[:message_body] || sender_name + " has accepted your project award for #{@project.name}."
    owner = @bid.project.user
    message = @bid.award_message

    current_user.reply_with_object_and_type(message.conversation, owner, body, nil, @bid, :bid_accepted_message)

    respond_to do |format|
      format.html { redirect_to(project_bid_path(@project, @bid), :notice => 'Bid Accepted') }
      format.text { render :text => "Bid Accepted" }
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
    redirect_to(project_path(@project), :alert => "Bids accepted for #{@project.name} between #{@project.created_at.to_formatted_s(:short)} and #{@project.bidding_end.to_formatted_s(:short)}.") unless @project.bidding_period?
  end

  def update_bid_state!(params)
    if params[:publish] && ! @bid.published?
      @bid.publish 
    elsif params[:cancel] 
      @bid.cancel
    end
  end
end
