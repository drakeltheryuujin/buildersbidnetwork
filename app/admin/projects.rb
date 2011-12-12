ActiveAdmin.register Project do
  filter :user
  filter :name
  filter :project_type, :as => :select
  filter :state, :as => :select, :collection => Project::STATES
  filter :created_at
  filter :updated_at
  filter :bidding_start
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
    column :bidding_start
    column :bidding_end

    column :pre_bid_meeting
    column :project_start
    column :project_end
    column :estimated_budget
    column :credit_value

    default_actions
  end
end
