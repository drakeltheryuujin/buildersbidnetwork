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
      elsif @filter.present? && @filter.to_sym == :future
        @projects = @projects.where(:user_id => current_user.id).where("bidding_start >= ?", Time.now)
      elsif @filter.present? && @filter.to_sym == :current
        @projects = @projects.
            where(:user_id => current_user.id).
            where("bidding_start <= ?", Time.now).
            where("bidding_end >= ?", Time.now)
      else
        @projects = @projects.find_all_by_user_id current_user.id
      end

      render :action => "developer"
    else
      if @filter.blank? || ! Bid::STATES.include?(@filter)
        @filter = :published.to_s
      end
      @bids = Bid.where :user_id => current_user.id, :state => @filter

      render :action => "contractor"
    end
  end
end
