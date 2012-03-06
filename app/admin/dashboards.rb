ActiveAdmin::Dashboards.build do

  credit_bl = PaymentCredit.sum(:amount)
  subscription_bl = SubscriptionPayment.sum(:amount)
  section "Bottom Line" do
    h3 do
      span "Credit Purchases"
      strong number_to_currency(credit_bl) 
    end
    h3 do 
      span "Subscription Purchases"
      strong number_to_currency(subscription_bl) 
    end
    h1 do
      span "Total"
      strong number_to_currency(credit_bl + subscription_bl) 
    end
  end

  section "Recent Projects" do
    table do
      tr do
        th 'Project'
        th 'Creator'
        th 'Bidding Close'
      end
      Project.order("created_at DESC").limit(5).collect do |project|
        tr do
          td link_to(project.name, admin_project_path(project))
          td link_to(project.user.name, admin_user_path(project.user))
          td project.bidding_end.to_formatted_s :long
        end
      end
    end
    strong { link_to "View All Projects", admin_projects_path }
  end

  section "Recent Bids" do
    table do
      tr do
        th 'Total'
        th 'Bidder'
        th 'Project'
      end
      Bid.order("created_at DESC").limit(5).collect do |bid|
        tr do
          td link_to(number_to_currency(bid.total), admin_bid_path(bid))
          td link_to(bid.user.name, admin_user_path(bid.user))
          td link_to(bid.project.name, admin_project_path(bid.project))
        end
      end
    end
    strong { link_to "View All Bids", admin_bids_path }
  end

  section "Recent Profiles" do
    ul do
      Profile.order("created_at DESC").limit(10).collect do |profile|
        li link_to(profile.name, admin_profile_path(profile))
      end
    end
    strong { link_to "View All Profiles", admin_profiles_path }
  end

  section "Recent Credit Purchases" do
    table do
      tr do
        th 'Created At'
        th 'Value'
        th 'Amount'
        th 'User'
      end
      PaymentCredit.order("created_at DESC").limit(5).collect do |pc|
        tr do
          td link_to(pc.created_at.to_formatted_s(:long), admin_payment_credit_path(pc))
          td pc.value
          td number_to_currency pc.amount
          td link_to pc.user.name, admin_user_path(pc.user)
        end
      end
    end
    strong { link_to "View All Credit Purchases", admin_payment_credits_path }
  end

  section "Recent Subscription Purchases" do
    table do
      tr do
        th 'Created At'
        th 'Interval'
        th 'Amount'
        th 'User'
      end
      SubscriptionPayment.order("created_at DESC").limit(5).collect do |sp|
        tr do
          td link_to(sp.created_at.to_formatted_s(:long), admin_subscription_payment_path(sp))
          td sp.interval.humanize
          td number_to_currency sp.amount
          td link_to sp.subscription.user.name, admin_user_path(sp.subscription.user)
        end
      end
    end
    strong { link_to "View All Subscription Purchases", admin_subscription_payments_path }
  end
  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
