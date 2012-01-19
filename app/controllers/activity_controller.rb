class ActivityController < ApplicationController
  before_filter :authenticate_user!

  def index
    filter = params[:filter]
    if current_user.developer?
      if filter.present? && Project::STATES.include?(filter.to_sym)
        @projects = Project.where :user_id => current_user.id, :state => filter
      elsif filter.present? && filter.to_sym == :past
        @projects = Project.where(:user_id => current_user.id).where("bidding_end <= ?", Time.now)
      elsif filter.present? && filter.to_sym == :future
        @projects = Project.where(:user_id => current_user.id).where("bidding_start >= ?", Time.now)
      elsif filter.present? && filter.to_sym == :current
        @projects = Project.
            where(:user_id => current_user.id).
            where("bidding_start <= ?", Time.now).
            where("bidding_end >= ?", Time.now)
      else
        @projects = Project.find_all_by_user_id current_user.id
      end

      render :action => "developer"
    else
      if filter.present? && Bid::STATES.include?(filter)
        @bids = Bid.where :user_id => current_user.id, :state => filter
      else
        @bids = Bid.find_all_by_user_id current_user.id
      end

      render :action => "contractor"
    end
  end
end