class CreditsController < ApplicationController
  PricePerCredit = 50
  GroupPackages = [[11, 500], [17, 750], [23, 1000], [30, 1250]]
  before_filter :authenticate_user!, :except => :index

  def index
  end

  def history
    @credit_adjustments = current_user.credit_adjustments
  end

  def new
    @pc = PaymentCredit.new
    if params[:value].present?
      @pc.value = params[:value].to_i
      @pc.amount = @pc.value * PricePerCredit
    elsif params[:package].present? && params[:package].to_i < GroupPackages.size()
      package = params[:package].to_i
      @pc.value = GroupPackages[package][0]
      @pc.amount = GroupPackages[package][1]
    else
      @pc.value = 1
      @pc.amount = @pc.value * PricePerCredit
    end
  end
  
  def create
    @pc = PaymentCredit.new(params[:payment_credit])
    @pc.user_id = current_user.id
    @pc.ip_address = request.remote_ip
    if @pc.purchase
      redirect_to credit_path(@pc), :notice => "Thank you for your payment." 
    else
      render :action => 'new'
    end
  end

  def show
    @credit = CreditAdjustment.find(params[:id])
    # TODO validate ownership
  end
end
