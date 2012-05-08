class BidDocumentsController < ApplicationController
	before_filter :authenticate_user!
  before_filter :get_bid_and_document, :only => [:show, :update, :edit, :destroy]
  before_filter :check_may_modify!, :only => [:update, :edit, :destroy]

  def index
  end
# need to have reference to @project?
  def destroy
    @bid_document.destroy
    redirect_to(project_bid_path(@project, @bid_document.bid), :notice => 'BidDocument was successfully destroyed.')
	end

  def show
    redirect_to project_bid_path(@project, @bid_document.bid)
  end
  
  def edit
    redirect_to project_bid_path(@project, @bid_document.bid)
  end
  
  def new
    @bid = Bid.find(params[:bid_id])
  end
  
  def create
    @bid = Bid.find(params[:bid_id])
    @bid_document = BidDocument.create(params[:bid_document])
    @bid_document.bid = @bid
    
    if @bid_document.save
      redirect_to(project_bid_path(@project, @bid_document.bid), :notice => 'BidDocument was successfully created.')
    else
      redirect_to(project_bid_path(@project, @bid_document.bid), :alert => @bid_document.errors.full_messages.join(' ') + 'BidDocument could not be created.')
    end
  end
  
  def update
    if @bid_document.update_attributes(params[:bid_document])
      respond_to do |format|
        format.text { render :text => @bid_document.description }
        format.html { redirect_to(project_bid_path(@project, @bid_document.bid), :notice => 'BidDocument was successfully updated.') }
      end
    else
      respond_to do |format|
        format.text { render :text => "Error updating description.", :status => :bad_request }
        format.html { redirect_to(project_bid_path(@project, @bid_document.bid), :alert => 'BidDocument could not be updated.') }
      end
    end
  end

  private

  def get_bid_and_document
    @bid = Bid.find(params[:bid_id])
    @bid_document = BidDocument.find(params[:id])
  end

  def check_may_modify!
    redirect_to(project_bid_path(@project, @bid_document.bid), :alert => "Access denied.") unless @bid.may_modify? current_user
  end
end
