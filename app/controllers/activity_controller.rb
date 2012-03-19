class ActivityController < ApplicationController
  before_filter :authenticate_user!

  def index
    @filter = params[:filter]
    if current_user.developer?
      @projects = Project.where(:user_id => current_user.id).order(:bidding_end)

      if :past.to_s == @filter
        @projects = @projects.where("bidding_end <= ?", Time.now).reverse_order
      else
        @projects = @projects.where("bidding_end > ?", Time.now)
        if @filter.present? && Project::STATES.include?(@filter)
          @projects = @projects.where :state => @filter
        else
          @projects = @projects.where :state => :published.to_s
          #@projects = @projects.find_all_by_user_id current_user.id
        end
      end

      render :action => "developer"
    else
      @bids = Bid.joins(:project).where(:user_id => current_user.id).order('projects.bidding_end')
      if :past.to_s == @filter
        @bids = @bids.where("projects.bidding_end <= :now", :now => Time.now).reverse_order
      else
        @bids = @bids.where("projects.bidding_end > :now", :now => Time.now)
        if @filter.blank? || ! Bid::STATES.include?(@filter)
          @filter = :published.to_s
        end
        @bids = @bids.where(:state => @filter)
        @bids = @bids.where("projects.bidding_end > :now", :now => Time.now) if @filter.to_sym == :published
      end

      render :action => "contractor"
    end
  end

  def private
    @projects = current_user.accessible_projects
  end
end
