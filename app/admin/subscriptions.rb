ActiveAdmin.register Subscription do
  menu false

  sidebar :subscription_adjustments, :only => :show do
    table_for subscription.subscription_adjustments do
      column :type do |sa|
        link_to sa.type, edit_admin_subscription_adjustment_path(sa)
      end
      column "Start" do |sa|
        sa.start_at.to_date.to_formatted_s(:short)
      end
      column :end_at do |sa|
        if sa.end_at.present?
          sa.end_at.to_date.to_formatted_s(:short)
        else
          status_tag "Open", :ok
        end
      end

    end
  end
  
end

ActiveAdmin.register SubscriptionAdjustment do
  menu false
  config.comments = false

  controller do
    def show
      sa = SubscriptionAdjustment.find params[:id]
      redirect_to admin_subscription_path(sa.subscription), :notice => flash[:notice], :alert => flash[:alert]
    end
  end
end
