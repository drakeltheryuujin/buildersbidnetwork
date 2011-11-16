class CreditsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @credit_adjustments = current_user.credit_adjustments
  end

  def new
    @pc = PaymentCredit.new
  end
  
  def create
    @pc = PaymentCredit.new(params[:payment_credit])
    @pc.user_id = current_user.id
    @pc.ip_address = request.remote_ip
    begin
      # maybe a transaction here? eg: @pc.transaction do ... end
		  @pc.save!
	    @pc.purchase!
      redirect_to credits_path, :notice => "Success" 
	  rescue Exception => e  
      flash[:alert] = e.message unless e.class == ActiveRecord::RecordInvalid
	    render :action => 'new'
    end
	end
end
