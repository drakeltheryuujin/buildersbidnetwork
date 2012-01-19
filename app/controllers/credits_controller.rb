class CreditsController < ApplicationController
  PricePerCredit = 50
  GroupPackages = [[11, 500], [17, 750], [23, 1000], [30, 1250]]
  before_filter :authenticate_user!

  def index
  end

  def history
    @credit_adjustments = current_user.credit_adjustments
  end

  def new
    @pc = PaymentCredit.new
    if params[:value].present?
      @pc.value = params[:value]
      @pc.amount = @pc.value * PricePerCredit
    elsif params[:package].present?
#package = [params[:package], GroupPackages.size()].min
      package = params[:package]
      @pc.value = GroupPackages[package.to_i][0]
      @pc.amount = GroupPackages[package.to_i][1]
    end
  end
  
  def create
    @pc = PaymentCredit.new(params[:payment_credit])
    @pc.user_id = current_user.id
    @pc.ip_address = request.remote_ip
    begin
      # maybe a transaction here? eg: @pc.transaction do ... end
		  @pc.save!
	    @pc.purchase!
      redirect_to history_credits_path, :notice => "Success" 
	  rescue Exception => e  
      flash[:alert] = e.message unless e.class == ActiveRecord::RecordInvalid
	    render :action => 'new'
    end
	end
end
