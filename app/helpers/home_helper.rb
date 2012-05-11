module HomeHelper
  def put_if_current_page(output, path)
    current_page?(path) ? output : ''
  end

  def put_if_current_page_and_param(output, path, param = :filter, value = nil)
    (current_page?(path) && value.to_s.eql?(params[param.to_s].to_s)) ? output : ''
  end

  def put_if_current_page_and_param_or_blank(output, path, param = :filter, value = nil)
    (current_page?(path) && (value.to_s.eql?(params[param.to_s].to_s) || params[param.to_s].blank?)) ? output : ''
  end

  def path_to_url(path)
    "#{request.protocol}#{request.host_with_port}#{path}"
  end

  def projects_posted_in_days_count(days = 30)
    Project.where(:state => :published.to_s).where("updated_at > :then", :then => (Time.now - days.days)).count
  end

  def projects_awarded_in_days_count(days = 30)
    Bid.where(:state => :accepted.to_s).where("updated_at > :then", :then => (Time.now - days.days)).count
  end

  def users_projects_count(user = current_user)
    Project.where(:user_id => user.id).count
  end

  def bids_on_users_projects_count(user = current_user)
    Bid.joins(:project).where(:projects => {:user_id => user.id}).count
  end
end
