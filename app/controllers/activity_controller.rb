class ActivityController < ApplicationController
  before_filter :authenticate_user!

  def index
    @filter = params[:filter]
    if current_user.developer?
      @projects = Project.order(:bidding_end)

      if @filter.present? && Project::STATES.include?(@filter.to_sym)
        @projects = @projects.where :user_id => current_user.id, :state => @filter
      elsif @filter.present? && @filter.to_sym == :past
        @projects = @projects.where(:user_id => current_user.id).where("bidding_end <= ?", Time.now)
      elsif @filter.present? && @filter.to_sym == :current
        @projects = @projects.where(:user_id => current_user.id).where("bidding_end >= ?", Time.now)
      else
        @projects = @projects.find_all_by_user_id current_user.id
      end

      render :action => "developer"
    else
      @bids = Bid.joins(:project).where(:user_id => current_user.id).order('projects.bidding_end')
      if :past.to_s == @filter
        @bids = @bids.where("projects.bidding_end <= :now", :now => Time.now)
      else
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
