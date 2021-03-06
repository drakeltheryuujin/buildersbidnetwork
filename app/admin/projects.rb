ActiveAdmin.register Project do
  filter :user
  filter :name
  filter :project_type, :as => :select
  filter :state, :as => :select, :collection => Project::STATES
  filter :created_at
  filter :updated_at
  filter :bidding_end
  filter :pre_bid_meeting
  filter :project_start
  filter :project_end
  filter :description
  filter :notes
  filter :estimated_budget
  filter :credit_value

  index do
    column :user
    column :name
    column :project_type
    column :state
    column :created_at
    column :updated_at
    column :bidding_end

    column :pre_bid_meeting
    column :project_start
    column :project_end
    column :estimated_budget
    column :credit_value

    default_actions
  end
  
  member_action :end_bidding do
    project = Project.find(params[:id])
    
    project.update_attribute :bidding_end, Time.now()
    
    if project.save(:validate => false)
      redirect_to({:action => :show}, :notice => "Bidding Ended!")
    else
      redirect_to({:action => :show}, :alert => project.errors.full_messages.join(', '))
    end
  end
  
  sidebar :actions, :only => :show

  sidebar :bids, :only => :show do
    table do
      tr do
        th 'Total'
        th 'Bidder'
      end
      project.bids.collect do |bid|
        tr do
          td link_to(number_to_currency(bid.total), admin_bid_path(bid))
          td link_to(bid.user.name, admin_user_path(bid.user))
        end
      end
    end
  end
end
