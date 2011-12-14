class NotificationsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :get_mailbox, :get_actor
  before_filter :check_current_subject_is_owner, :only => [:show, :update, :destroy]
  
  def index
    filter = params[:filter]

    notifs = Notification.recipient(@actor).order("notifications.created_at DESC")
#if (options[:read].present? and options[:read]==false) or (options[:unread].present? and options[:unread]==true)
#notifs = notifs.unread
#end
    if filter.present? && filter.to_sym == :unread
      notifs = notifs.unread
    elsif filter.present? && filter.to_sym == :trash
      notifs = notifs.where('receipts.trashed' => true)
    elsif filter.present? && filter.to_sym == :sent
      notifs = notifs.where('receipts.mailbox_type' => 'sentbox', 'receipts.trashed' => false)
    else
      notifs = notifs.not_trashed.where('receipts.mailbox_type' => 'inbox')
    end

    @notifications = notifs.page(params[:page]).per(10)
  end

  def show
    
  end

  def new

  end

  def edit

  end

  def create

  end

  def update
    if params[:read].present?
      if params[:read].eql?("Read")
        @actor.read @notification
      elsif params[:read].eql?("Unread")
        @actor.unread @notification
      end
    end

    redirect_to notifications_path
  end
  
  def update_all
    @notifications= @mailbox.notifications.all
    @actor.read @notifications

    redirect_to notifications_path
  end

  def destroy
    @notification.receipt_for(@actor).move_to_trash

    redirect_to notifications_path
  end

  private

  def get_mailbox
    @mailbox = current_user.mailbox
  end

  def get_actor
    @actor = current_user
  end


  def check_current_subject_is_owner
    
    @notification = Notification.find_by_id(params[:id])

    if @notification.nil? #TODO or !@notification.is_receiver?(@actor)
      redirect_to notifications_path
	    return
    end
  end

end
