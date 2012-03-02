ActiveAdmin.register User do
  menu :priority => 1

  index do
    column :id
    column :email
    column :failed_attempts
    default_actions
  end
  
  action_item :only => :show do
    link_to "View Profile", profile_path(user.profile) unless user.profile.blank?
  end

  member_action :grant_credits, :method => :post do
    user = User.find(params[:id])
    granted_credit = GrantedCredit.new(params[:granted_credit])
    granted_credit.user_id = user.id
    granted_credit.granted_by_id = current_user.id
    if granted_credit.save
      redirect_to({:action => :show}, :notice => "Granted!")
    else
      redirect_to({:action => :show}, :alert => granted_credit.errors.full_messages.join(', '))
    end
  end

  member_action :grant_subscription, :method => :get do
    user = User.find(params[:id])
    subscription = Subscription.find_or_initialize_by_user_id params[:id]
    granted_subscription = subscription.subscription_adjustments.build({:adjustment_type => :granted_subscription})
    granted_subscription.start_at = subscription.valid_until || Time.now # start at the end of the current subscription
    granted_subscription.end_at = nil # open ended by default
    granted_subscription.granted_by = current_user
    if subscription.save
      redirect_to({:action => :show}, :notice => "New subscription created!")
    else
      redirect_to({:action => :show}, :alert => subscription.errors.full_messages.join(', '))
    end
  end

  sidebar :relations, :only => :show do
    attributes_table_for user do
      row("Profile") { (user.profile.present? ? link_to(user.profile.name, admin_profile_path(user.profile)) : "No Profile Yet") }
      row("Subscription") {
        if user.subscription.present?
          link_to (user.subscription.valid_until.nil? ? "Ongoing" : user.subscription.valid_until.to_date.to_formatted_s(:short)), admin_subscription_path(user.subscription) 
        else
          link_to "<h3>Grant Subscription</h3>".html_safe, grant_subscription_admin_user_path(user)
        end
      }
    end

    if user.developer?
      table_for user.project do
        column "Projects" do |project|
          link_to project.name, admin_project_path(project)
        end
      end
    else
      table_for user.bids do
        column "Bids" do |bid|
          link_to bid.project.name, admin_bid_path(bid)
        end
      end
    end

    panel "Credits: #{user.credits}" do
      table_for user.credit_adjustments do
        column "Date" do |credit_adjustment|
          credit_adjustment.created_at.to_date.to_formatted_s :short
        end
        column :type
        column :value
      end
    end
  end

  sidebar :actions, :only => :show
end
