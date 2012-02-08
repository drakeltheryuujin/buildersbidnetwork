class SubscriptionsController < ApplicationController
  def index
  end

  def new
    @subscription = Subscription.new
    if params[:package].present? && params[:package] == :yearly.to_s
      @subscription.subscription_adjustments.build(:adjustment_type => :subscription_payment, :amount => 959.40)
    else
      @subscription.subscription_adjustments.build(:adjustment_type => :recurring_payment, :amount => 89.95)
    end
    @subscription.valid_until = Time.now + 1.year
  end

  def create
    @subscription = Subscription.new(params[:subscription])
    @subscription.user_id = current_user.id
    @subscription.subscription_adjustments.first.ip_address = request.remote_ip
    if @subscription.purchase!
#redirect_to subscription_path(@subscription), :notice => "Thank you for your payment." 
      redirect_to subscriptions_path, :notice => "Thank you for your payment." 
    else
      render :action => 'new'
    end
  end
end
