##
##
# Acts as controller for SubscriptionPayments.
##
##
class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!, :except => :index
  before_filter :check_subscription_expiring!, :only => [:new, :create]

  def index
  end

  def new
    package = (SubscriptionPayment::INTERVALS.include?(params[:package]) ? params[:package] : SubscriptionPayment::INTERVALS.first)
    @subscription_payment = SubscriptionPayment.new(
        :interval => package, 
        :amount => SubscriptionPayment::PACKAGES[package.to_sym])
  end

  def create
    @subscription = Subscription.find_or_initialize_by_user_id current_user.id
    @subscription_payment = @subscription.subscription_adjustments.build(params[:subscription_payment])
    @subscription_payment.ip_address = request.remote_ip
    @subscription_payment.start_at = @subscription.valid_until || Time.now # start at the end of the current subscription
    if @subscription_payment.purchase!(@subscription)
      redirect_to subscription_path(@subscription_payment), :notice => "Thank you for your payment." 
    else
      render :action => 'new'
    end
  end

  def show
    @subscription_payment = SubscriptionPayment.find(params[:id])
    return redirect_to(subscriptions_path, :alert => 'Access denied.') unless @subscription_payment.subscription.user == current_user 
  end

  def status
    @subscription = current_user.subscription
  end

  def cancel
    @subscription = current_user.subscription
    if @subscription.cancel!
      redirect_to(subscriptions_path, :notice => 'Subscription canceled.')
    else
      render :action => :status
    end
  end

  private

  def check_subscription_expiring!
    redirect_to subscriptions_path, :notice => "Your current subscription is not due to expire." if current_user.subscription.present? && current_user.subscription.valid_until.nil?
  end
end
